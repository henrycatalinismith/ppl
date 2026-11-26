use std::fs;
use std::path::{Path, PathBuf};

use git2::{Repository, Signature};

use crate::entity::{AddressBook, Contact};
use crate::error::{Error, Result};
use crate::vcard::{self, VcardError};

pub struct Disk {
    path: PathBuf,
}

impl Disk {
    pub fn new(path: PathBuf) -> Disk {
        Disk { path }
    }

    pub fn create_address_book(path: &Path) -> Result<Disk> {
        fs::create_dir_all(path)?;
        let dot_ppl = path.join(".ppl");
        fs::create_dir_all(&dot_ppl)?;
        fs::OpenOptions::new()
            .create(true)
            .append(true)
            .open(dot_ppl.join("config"))?;
        Ok(Disk::new(path.to_path_buf()))
    }

    fn filename(&self, id: &str) -> PathBuf {
        self.path.join(format!("{id}.vcf"))
    }

    fn load_address_book(&self) -> Result<AddressBook> {
        let mut names: Vec<String> = fs::read_dir(&self.path)?
            .filter_map(|e| e.ok())
            .filter_map(|e| e.file_name().into_string().ok())
            .filter(|n| n.ends_with(".vcf") && !n.starts_with('.'))
            .collect();
        names.sort();
        let mut book = AddressBook::default();
        for name in names {
            let id = &name[..name.len() - 4];
            if let Some(c) = self.load_contact(id)? {
                book.contacts.push(c);
            }
        }
        Ok(book)
    }

    fn load_contact(&self, id: &str) -> Result<Option<Contact>> {
        let filename = self.filename(id);
        if !filename.exists() {
            return Ok(None);
        }
        let bytes = fs::read(filename)?;
        let mut contact = vcard::decode(&bytes).map_err(|e| match e {
            VcardError::Invalid(m) | VcardError::Other(m) => Error::Other(m),
        })?;
        contact.id = id.to_string();
        Ok(Some(contact))
    }

    fn save_contact(&self, contact: &Contact) -> Result<()> {
        let encoded = vcard::encode(contact).map_err(Error::Other)?;
        fs::write(self.filename(&contact.id), encoded)?;
        Ok(())
    }

    fn delete_contact(&self, contact: &Contact) -> Result<()> {
        fs::remove_file(self.filename(&contact.id))?;
        Ok(())
    }
}

pub struct Git {
    disk: Disk,
    repo: Repository,
}

impl Git {
    pub fn new(disk: Disk) -> Result<Git> {
        let repo = Repository::open(&disk.path)?;
        Ok(Git { disk, repo })
    }

    pub fn create_address_book(path: &Path) -> Result<()> {
        Repository::init(path)?;
        let disk = Disk::create_address_book(path)?;
        let git = Git::new(disk)?;
        git.add(".ppl/config")?;
        git.commit("first commit")?;
        Ok(())
    }

    fn head_tree(&self) -> Result<git2::Tree<'_>> {
        Ok(self.repo.head()?.peel_to_tree()?)
    }

    fn load_address_book(&self) -> Result<AddressBook> {
        let tree = self.head_tree()?;
        let mut book = AddressBook::default();
        for entry in tree.iter() {
            let Ok(name) = entry.name() else { continue };
            if name.len() < 4 || !name.ends_with(".vcf") {
                continue;
            }
            if let Some(c) = self.load_contact(&name[..name.len() - 4])? {
                book.contacts.push(c);
            }
        }
        Ok(book)
    }

    fn load_contact(&self, id: &str) -> Result<Option<Contact>> {
        let filename = format!("{id}.vcf");
        let tree = self.head_tree()?;
        let blob = match tree.get_path(Path::new(&filename)) {
            Ok(entry) => match entry.to_object(&self.repo)?.into_blob() {
                Ok(blob) => blob,
                Err(_) => return Ok(None),
            },
            Err(_) => return Ok(None),
        };
        let mut contact = vcard::decode(blob.content()).map_err(|e| match e {
            VcardError::Invalid(_) => Error::Other(format!("{filename} contains invalid data")),
            VcardError::Other(m) => Error::Other(m),
        })?;
        contact.id = id.to_string();
        Ok(Some(contact))
    }

    fn save_contact(&self, contact: &Contact) -> Result<()> {
        self.disk.save_contact(contact)?;
        self.add(&format!("{}.vcf", contact.id))?;
        self.commit(&format!("save_contact({})", contact.id))
    }

    fn delete_contact(&self, contact: &Contact) -> Result<()> {
        let mut index = self.repo.index()?;
        index.remove_path(Path::new(&format!("{}.vcf", contact.id)))?;
        index.write()?;
        self.commit(&format!("remove_contact({})", contact.id))?;
        self.disk.delete_contact(contact)
    }

    fn add(&self, file: &str) -> Result<()> {
        let mut index = self.repo.index()?;
        index.add_path(Path::new(file))?;
        index.write()?;
        Ok(())
    }

    fn commit(&self, message: &str) -> Result<()> {
        let mut index = self.repo.index()?;
        let tree = self.repo.find_tree(index.write_tree()?)?;
        let parent = self.repo.head().ok().and_then(|h| h.peel_to_commit().ok());
        let parents: Vec<&git2::Commit> = parent.iter().collect();
        let author = signature()?;
        self.repo
            .commit(Some("HEAD"), &author, &author, message, &tree, &parents)?;
        Ok(())
    }
}

fn signature() -> Result<Signature<'static>> {
    let config = git2::Config::open_default().ok();
    let get = |key: &str| config.as_ref().and_then(|c| c.get_string(key).ok());
    let user = std::env::var("USER").unwrap_or_default();
    let email = get("user.email").unwrap_or_else(|| format!("{user}@{}", hostname()));
    let name = get("user.name").unwrap_or(user);
    Ok(Signature::now(&name, &email)?)
}

fn hostname() -> String {
    std::process::Command::new("hostname")
        .output()
        .ok()
        .and_then(|o| String::from_utf8(o.stdout).ok())
        .map(|s| s.trim().to_string())
        .unwrap_or_default()
}

pub enum Storage {
    Disk(Disk),
    Git(Git),
}

impl Storage {
    /// Opens the address book at `path`, using git if it's a repository.
    pub fn open(path: PathBuf) -> Result<Storage> {
        if !path.is_dir() {
            return Err(Error::Other(format!(
                "No such file or directory @ dir_initialize - {}",
                path.display()
            )));
        }
        let disk = Disk::new(path.clone());
        if path.join(".git").exists() {
            Ok(Storage::Git(Git::new(disk)?))
        } else {
            Ok(Storage::Disk(disk))
        }
    }

    pub fn path(&self) -> &Path {
        match self {
            Storage::Disk(d) => &d.path,
            Storage::Git(g) => &g.disk.path,
        }
    }

    pub fn load_address_book(&self) -> Result<AddressBook> {
        match self {
            Storage::Disk(d) => d.load_address_book(),
            Storage::Git(g) => g.load_address_book(),
        }
    }

    pub fn load_contact(&self, id: &str) -> Result<Option<Contact>> {
        match self {
            Storage::Disk(d) => d.load_contact(id),
            Storage::Git(g) => g.load_contact(id),
        }
    }

    pub fn require_contact(&self, id: &str) -> Result<Contact> {
        self.load_contact(id)?
            .ok_or_else(|| Error::ContactNotFound(id.to_string()))
    }

    pub fn save_contact(&self, contact: &Contact) -> Result<()> {
        match self {
            Storage::Disk(d) => d.save_contact(contact),
            Storage::Git(g) => g.save_contact(contact),
        }
    }

    pub fn delete_contact(&self, contact: &Contact) -> Result<()> {
        match self {
            Storage::Disk(d) => d.delete_contact(contact),
            Storage::Git(g) => g.delete_contact(contact),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::entity::Name;

    fn bob() -> Contact {
        Contact {
            id: "bob".into(),
            name: Name::parse("Bob Smith"),
            ..Contact::default()
        }
    }

    #[test]
    fn disk_round_trip() {
        let dir = tempfile::tempdir().unwrap();
        let storage = Storage::open(dir.path().to_path_buf()).unwrap();
        storage.save_contact(&bob()).unwrap();
        let book = storage.load_address_book().unwrap();
        assert_eq!(book.contacts.len(), 1);
        assert_eq!(book.contacts[0].name.full, "Bob Smith");
        storage.delete_contact(&bob()).unwrap();
        assert!(storage.load_contact("bob").unwrap().is_none());
    }

    #[test]
    fn git_round_trip() {
        let dir = tempfile::tempdir().unwrap();
        Git::create_address_book(dir.path()).unwrap();
        let storage = Storage::open(dir.path().to_path_buf()).unwrap();
        assert!(matches!(storage, Storage::Git(_)));
        storage.save_contact(&bob()).unwrap();
        assert_eq!(
            storage.require_contact("bob").unwrap().name.full,
            "Bob Smith"
        );
        storage.delete_contact(&bob()).unwrap();
        assert_eq!(
            storage.require_contact("bob"),
            Err(Error::ContactNotFound("bob".into()))
        );
    }
}
