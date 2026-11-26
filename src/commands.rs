use std::cell::OnceCell;
use std::collections::HashMap;
use std::io::{self, BufRead, IsTerminal, Read, Write};
use std::os::unix::process::CommandExt;
use std::process;

use chrono::{Local, NaiveDate};

use crate::config::Configuration;
use crate::dates;
use crate::entity::{AddressBook, Contact, EmailAddress, Name, PhoneNumber, PostalAddress};
use crate::error::{Error, Result};
use crate::format::{self, Colors};
use crate::ini::Value;
use crate::opts::{arg, flag, Options, Outcome, Parser, Switch};
use crate::storage::{Git, Storage};

pub const VERSION: &str = env!("CARGO_PKG_VERSION");

const BASH_COMPLETION: &str = include_str!("../completions/bash");
const ZSH_COMPLETION: &str = include_str!("../completions/zsh");

pub struct Command {
    pub name: &'static str,
    pub description: &'static str,
    pub kind: Kind,
}

pub enum Kind {
    Builtin {
        banner: &'static str,
        switches: &'static [Switch],
    },
    /// Runs a shell command in the address book directory.
    External(&'static str),
}

const fn builtin(
    name: &'static str,
    description: &'static str,
    banner: &'static str,
    switches: &'static [Switch],
) -> Command {
    Command {
        name,
        description,
        kind: Kind::Builtin { banner, switches },
    }
}

const fn external(name: &'static str, command: &'static str, description: &'static str) -> Command {
    Command {
        name,
        description,
        kind: Kind::External(command),
    }
}

const PO_BOX: Switch = Switch {
    show_short: false,
    ..arg(Some('p'), "po-box", "<po-box>", "po_box", "")
};

pub const COMMANDS: &[Command] = &[
    builtin(
        "add",
        "Add a new contact",
        "usage: ppl add <contact> <name>",
        &[],
    ),
    builtin("age", "List or show contacts's ages", "usage: ppl age", &[]),
    builtin(
        "bday",
        "List, show or change birthdays",
        "usage: ppl birthday <contact> [<date>]",
        &[],
    ),
    builtin(
        "completion",
        "Output shell completion function",
        "usage: ppl completion <shell>",
        &[],
    ),
    builtin(
        "email",
        "Show or change a contact's email address",
        "usage: ppl email <contact> [<email-address>]",
        &[
            flag(Some('d'), "delete", "delete", true, "delete email address"),
            flag(
                Some('p'),
                "preferred",
                "preferred",
                true,
                "mark address as preferred",
            ),
            flag(
                Some('P'),
                "not-preferred",
                "preferred",
                false,
                "mark address as not preferred",
            ),
            arg(
                None,
                "format",
                "<format>",
                "format",
                "specify a custom output format",
            ),
        ],
    ),
    external(
        "grep",
        "git grep",
        "Execute 'git grep' in the address book directory",
    ),
    builtin(
        "help",
        "Show a list of commands",
        "Usage: ppl [options]",
        &[],
    ),
    builtin(
        "init",
        "Create an empty address book",
        "usage: ppl init [directory]",
        &[],
    ),
    builtin(
        "ls",
        "List all contacts",
        "usage: ppl ls",
        &[
            arg(
                None,
                "format",
                "<format>",
                "format",
                "specify a custom output format",
            ),
            arg(
                None,
                "pretty",
                "<format>",
                "pretty",
                "specify a custom output format",
            ),
        ],
    ),
    builtin(
        "mutt",
        "Integration with mutt's query_command",
        "usage: ppl mutt <query>",
        &[flag(
            Some('i'),
            "ignore-case",
            "ignore_case",
            true,
            "Turn off case sensitivity",
        )],
    ),
    builtin(
        "mv",
        "Rename a contact",
        "usage: ppl mv <contact> <new ID>",
        &[],
    ),
    builtin(
        "name",
        "List, show or change names",
        "usage: ppl name <contact> [<name>]",
        &[
            arg(Some('f'), "family", "<family-name(s)>", "family", ""),
            arg(Some('g'), "given", "<given-name(s)>", "given", ""),
            arg(Some('m'), "middle", "<middle-name(s)>", "middle", ""),
            arg(Some('p'), "prefix", "<prefix>", "prefix", ""),
            arg(Some('s'), "suffix", "<suffix>", "suffix", ""),
        ],
    ),
    builtin(
        "nick",
        "List, show or change nicknames",
        "usage: ppl nick <contact> [<nickname>]",
        &[
            flag(Some('d'), "delete", "delete", true, "delete nickname"),
            flag(
                None,
                "no-color",
                "no_color",
                true,
                "turn off colored output",
            ),
        ],
    ),
    builtin(
        "org",
        "List, show or change organizations",
        "usage: ppl org <contact> [<organization>]",
        &[flag(
            Some('d'),
            "delete",
            "delete",
            true,
            "delete organization",
        )],
    ),
    builtin(
        "phone",
        "List, show or change phone numbers",
        "usage: ppl phone <contact> [<number>]",
        &[
            flag(Some('d'), "delete", "delete", true, "delete phone number"),
            arg(
                Some('t'),
                "type",
                "<type>",
                "type",
                "set the phone number's type",
            ),
            flag(
                Some('p'),
                "preferred",
                "preferred",
                true,
                "mark phone number as preferred",
            ),
            flag(
                Some('P'),
                "not-preferred",
                "preferred",
                false,
                "mark phone number as not preferred",
            ),
        ],
    ),
    builtin(
        "post",
        "List, show or change postal addresses",
        "usage: ppl post <contact> [address]",
        &[
            arg(Some('s'), "street", "<street-address>", "street", ""),
            arg(Some('z'), "postal-code", "<postal-code>", "postal_code", ""),
            PO_BOX,
            arg(Some('l'), "locality", "<locality>", "locality", ""),
            arg(Some('r'), "region", "<region>", "region", ""),
            arg(Some('c'), "country", "<country>", "country", ""),
            flag(Some('d'), "delete", "delete", true, ""),
            arg(Some('m'), "move", "<new-id>", "new_id", ""),
            flag(
                Some('p'),
                "preferred",
                "preferred",
                true,
                "mark address as preferred",
            ),
            flag(
                Some('P'),
                "not-preferred",
                "preferred",
                false,
                "mark address as not preferred",
            ),
        ],
    ),
    external(
        "pull",
        "git pull",
        "Execute 'git pull' in the address book directory",
    ),
    external(
        "push",
        "git push",
        "Execute 'git push' in the address book directory",
    ),
    external(
        "remote",
        "git remote",
        "Execute 'git remote' in the address book directory",
    ),
    builtin("rm", "Delete a contact", "usage: ppl rm <contact>", &[]),
    builtin(
        "scrape",
        "Scrape contact details from stdin",
        "usage: ppl scrape [<options>]",
        &[
            flag(
                Some('q'),
                "quiet",
                "quiet",
                true,
                "Add contacts to the address book without prompting",
            ),
            flag(
                Some('s'),
                "sender",
                "sender",
                true,
                "Scrape the sender's contact details",
            ),
        ],
    ),
    builtin("shell", "Interactive mode", "usage: ppl shell", &[]),
    builtin(
        "show",
        "Display the full details of a contact",
        "usage: ppl show <contact>",
        &[],
    ),
    builtin(
        "url",
        "List, show or change URLs",
        "usage: ppl url <contact> [<url>]",
        &[flag(Some('d'), "delete", "delete", true, "delete url")],
    ),
    builtin(
        "version",
        "Display ppl version information",
        "usage: ppl version",
        &[],
    ),
];

fn find_command(name: &str) -> Option<&'static Command> {
    COMMANDS.iter().find(|c| c.name == name)
}

/// What the first argument resolved to.
enum Route {
    Command(&'static Command),
    /// A `!`-prefixed alias, which runs its value as a shell command.
    Alias(String),
}

fn route(argument: Option<&str>, aliases: &HashMap<String, Value>) -> Result<Route> {
    if let Some(arg) = argument {
        if let Some(c) = find_command(arg) {
            return Ok(Route::Command(c));
        }
        if let Some(target) = aliases.get(arg) {
            let Value::Str(target) = target else {
                return Err(Error::Other(format!(
                    "undefined method 'match' for {}",
                    target.ruby_description()
                )));
            };
            if let Some(command) = target.strip_prefix('!') {
                return Ok(Route::Alias(command.to_string()));
            }
            if let Some(c) = find_command(target) {
                return Ok(Route::Command(c));
            }
        }
    }
    Ok(Route::Command(find_command("help").unwrap()))
}

/// Writes to stdout and stderr like Ruby's `puts`, minus carriage returns.
fn line(s: &str) {
    let s = s.replace('\r', "");
    let mut out = io::stdout().lock();
    let _ = out.write_all(s.as_bytes());
    if !s.ends_with('\n') {
        let _ = out.write_all(b"\n");
    }
}

fn error_line(s: &str) {
    let s = s.replace('\r', "");
    if s.ends_with('\n') {
        eprint!("{s}");
    } else {
        eprintln!("{s}");
    }
}

pub struct App {
    config: Configuration,
    storage: OnceCell<Storage>,
    today: NaiveDate,
}

fn usage(message: &str) -> Error {
    Error::Usage(message.to_string())
}

impl App {
    pub fn new(config: Configuration) -> App {
        App {
            config,
            storage: OnceCell::new(),
            today: Local::now().date_naive(),
        }
    }

    fn storage(&self) -> Result<&Storage> {
        if self.storage.get().is_none() {
            let path = self.config.address_book_path().map_err(Error::Other)?;
            let storage = Storage::open(path)?;
            let _ = self.storage.set(storage);
        }
        Ok(self.storage.get().unwrap())
    }

    fn colors(&self, command: &str) -> Colors {
        self.config.command_colors(command)
    }

    /// Runs ppl with the given arguments and returns the exit status.
    pub fn run(&self, mut args: Vec<String>) -> i32 {
        let first = if args.is_empty() {
            None
        } else {
            Some(args.remove(0))
        };
        let aliases = self.config.aliases();

        let routed = match route(first.as_deref(), &aliases) {
            Ok(r) => r,
            Err(e) => return self.report(Err(e), ""),
        };
        let (name, banner, switches) = match routed {
            Route::Alias(command) => return self.report(self.external(&command, args), ""),
            Route::Command(Command {
                kind: Kind::External(command),
                ..
            }) => return self.report(self.external(command, args), ""),
            Route::Command(Command {
                name,
                kind: Kind::Builtin { banner, switches },
                ..
            }) => (*name, *banner, *switches),
        };

        let parser = Parser { banner, switches };
        let help = parser.help();
        let result = parser.parse(args).and_then(|outcome| match outcome {
            Outcome::Help(text) => {
                line(&text);
                Ok(true)
            }
            Outcome::Parsed(args, options) => self.execute(name, args, options),
        });
        self.report(result, &help)
    }

    fn report(&self, result: Result<bool>, help: &str) -> i32 {
        match result {
            Ok(true) => 0,
            Ok(false) => 1,
            Err(Error::Usage(message)) => {
                error_line(&message);
                error_line(help);
                1
            }
            Err(e) => {
                error_line(&e.to_string());
                1
            }
        }
    }

    fn execute(&self, name: &str, args: Vec<String>, options: Options) -> Result<bool> {
        match name {
            "add" => self.add(&args),
            "age" => self.age(&args),
            "bday" => self.bday(&args),
            "completion" => self.completion(&args),
            "email" => self.email(&args, &options),
            "help" => self.help(),
            "init" => self.init(&args),
            "ls" => self.ls(&options),
            "mutt" => self.mutt(&args, &options),
            "mv" => self.mv(&args),
            "name" => self.name(&args, &options),
            "nick" => self.attribute("nick", &args, &options, |c| &mut c.nicknames),
            "org" => self.attribute("org", &args, &options, |c| &mut c.organizations),
            "phone" => self.phone(&args, &options),
            "post" => self.post(&args, &options),
            "rm" => self.rm(&args),
            "scrape" => self.scrape(&options),
            "shell" => self.shell(),
            "show" => self.show(&args),
            "url" => self.attribute("url", &args, &options, |c| &mut c.urls),
            "version" => {
                line(&format!("ppl version {VERSION}"));
                Ok(true)
            }
            _ => unreachable!("unknown command {name}"),
        }
    }

    fn external(&self, command: &str, args: Vec<String>) -> Result<bool> {
        let mut command = command.to_string();
        if !args.is_empty() {
            command.push(' ');
            command.push_str(&args.join(" "));
        }
        std::env::set_current_dir(self.storage()?.path())?;
        let err = process::Command::new("/bin/sh")
            .arg("-c")
            .arg(&command)
            .exec();
        Err(err.into())
    }

    fn add(&self, args: &[String]) -> Result<bool> {
        let id = args.first().ok_or_else(|| usage("No contact specified"))?;
        let name = args.get(1).ok_or_else(|| usage("No name specified"))?;
        let contact = Contact {
            id: id.clone(),
            name: Name::parse(name),
            ..Contact::default()
        };
        self.storage()?.save_contact(&contact)?;
        Ok(true)
    }

    fn age(&self, args: &[String]) -> Result<bool> {
        let colors = self.colors("age");
        match args.first() {
            None => {
                let book = self.storage()?.load_address_book()?;
                line(&format::address_book_ages(&book, &colors, self.today));
            }
            Some(id) => {
                let contact = self.storage()?.require_contact(id)?;
                line(&format::contact_age(&contact, &colors, self.today));
            }
        }
        Ok(true)
    }

    fn bday(&self, args: &[String]) -> Result<bool> {
        let colors = self.colors("bday");
        match (args.first(), args.get(1)) {
            (None, _) => {
                let book = self.storage()?.load_address_book()?;
                line(&format::address_book_birthdays(&book, &colors));
                Ok(true)
            }
            (Some(id), None) => {
                let contact = self.storage()?.require_contact(id)?;
                let birthday = format::contact_birthday(&contact, &colors);
                if birthday.is_empty() {
                    return Ok(false);
                }
                line(&birthday);
                Ok(true)
            }
            (Some(id), Some(date)) => {
                let mut contact = self.storage()?.require_contact(id)?;
                let birthday = dates::parse(date, self.today)
                    .ok_or_else(|| usage(&format!("Invalid date '{date}'")))?;
                contact.birthday = Some(birthday);
                self.storage()?.save_contact(&contact)?;
                Ok(true)
            }
        }
    }

    fn completion(&self, args: &[String]) -> Result<bool> {
        let shell = args.first().ok_or_else(|| usage("No shell specified"))?;
        let script = match shell.as_str() {
            "bash" => BASH_COMPLETION,
            "zsh" => ZSH_COMPLETION,
            _ => return Err(Error::CompletionNotFound(shell.clone())),
        };
        line(script);
        Ok(true)
    }

    fn email(&self, args: &[String], options: &Options) -> Result<bool> {
        let storage = self.storage()?;
        let colors = self.colors("email");
        match (args.first(), args.get(1)) {
            (None, _) => {
                let book = storage.load_address_book()?;
                line(&format::address_book_email_addresses(&book, &colors));
            }
            (Some(id), None) => {
                let contact = storage.require_contact(id)?;
                let output = match options.str("format") {
                    None => format::contact_email_addresses(&contact, &colors),
                    Some(f) => contact
                        .email_addresses
                        .iter()
                        .map(|e| format::custom_email_address(f, e))
                        .collect::<Vec<_>>()
                        .join("\n"),
                };
                line(&output);
            }
            (Some(id), Some(address)) => {
                let mut contact = storage.require_contact(id)?;
                if options.is_set("delete") {
                    contact.email_addresses.retain(|e| &e.address != address);
                } else {
                    let exists = contact
                        .email_addresses
                        .iter()
                        .any(|e| &e.address == address);
                    if !exists {
                        contact.email_addresses.push(EmailAddress::new(address));
                    }
                    match options.flag("preferred") {
                        Some(true) => {
                            for e in &mut contact.email_addresses {
                                e.preferred = &e.address == address;
                            }
                        }
                        Some(false) => {
                            for e in contact
                                .email_addresses
                                .iter_mut()
                                .filter(|e| &e.address == address)
                                .take(1)
                            {
                                e.preferred = false;
                            }
                        }
                        None => {}
                    }
                }
                storage.save_contact(&contact)?;
            }
        }
        Ok(true)
    }

    fn help(&self) -> Result<bool> {
        let mut commands: Vec<&Command> = COMMANDS.iter().collect();
        commands.sort_by_key(|c| c.name);
        let width = commands.iter().map(|c| c.name.len()).max().unwrap_or(0);
        line("usage: ppl <command>");
        line("");
        for c in commands.iter().filter(|c| c.name != "help") {
            line(&format!("   {:width$}   {}", c.name, c.description));
        }
        line("");
        Ok(true)
    }

    fn init(&self, args: &[String]) -> Result<bool> {
        let path = match args.first() {
            Some(p) => std::path::PathBuf::from(p),
            None => std::env::current_dir()?,
        };
        Git::create_address_book(&path)?;
        if !self.config.has_default_address_book() {
            let path = crate::config::expand_path(&path.to_string_lossy());
            self.config.set_default_address_book(&path)?;
        }
        Ok(true)
    }

    fn ls(&self, options: &Options) -> Result<bool> {
        let book = self.storage()?.load_address_book()?;
        let format = if let Some(preset) = options.str("pretty") {
            let presets = self
                .config
                .pretty()
                .ok_or_else(|| Error::Other("undefined method '[]' for nil".into()))?;
            match presets.get(preset) {
                Some(Value::Str(f)) => Some(f.clone()),
                Some(v) => {
                    return Err(Error::Other(format!(
                        "undefined method 'scan' for {}",
                        v.ruby_description()
                    )))
                }
                None => return Err(Error::Other("undefined method 'scan' for nil".into())),
            }
        } else {
            options.str("format").map(String::from)
        };
        let output = match format {
            Some(f) => book
                .contacts
                .iter()
                .map(|c| format::custom_contact(&f, c, self.today))
                .collect::<Vec<_>>()
                .join("\n"),
            None => format::address_book_one_line(&book, &self.colors("ls")),
        };
        line(&output);
        Ok(true)
    }

    fn mutt(&self, args: &[String], options: &Options) -> Result<bool> {
        let query = args
            .first()
            .ok_or_else(|| usage("You must provide a query"))?;
        let ignore_case = options.is_set("ignore_case");
        let matches_query = |s: &str| {
            if ignore_case {
                s.to_lowercase().contains(&query.to_lowercase())
            } else {
                s.contains(query.as_str())
            }
        };

        let book = self.storage()?.load_address_book()?;
        let mut matches = AddressBook::default();
        for contact in &book.contacts {
            if contact.email_addresses.is_empty() {
                continue;
            }
            if matches_query(&contact.name.full) {
                matches.contacts.push(contact.clone());
                continue;
            }
            let addresses: Vec<EmailAddress> = contact
                .email_addresses
                .iter()
                .filter(|e| matches_query(&e.address))
                .cloned()
                .collect();
            if !addresses.is_empty() {
                matches.contacts.push(Contact {
                    email_addresses: addresses,
                    ..contact.clone()
                });
            }
        }

        if matches.contacts.is_empty() {
            line("No matches");
            return Ok(false);
        }
        let count =
            |b: &AddressBook| -> usize { b.contacts.iter().map(|c| c.email_addresses.len()).sum() };
        let summary = format!(
            "Searching address book... {} email addresses... {} matching:",
            count(&book),
            count(&matches)
        );
        let output = format!("{summary}\n{}", format::address_book_mutt_query(&matches));
        line(crate::rb::strip(&output));
        Ok(true)
    }

    fn mv(&self, args: &[String]) -> Result<bool> {
        let old_id = args.first().ok_or_else(|| usage("No contact specified"))?;
        let new_id = args.get(1).ok_or_else(|| usage("No new ID specified"))?;
        let storage = self.storage()?;
        let mut contact = storage.require_contact(old_id)?;
        if storage.load_contact(new_id)?.is_some() {
            error_line(&format!("There is already a contact with ID '{new_id}'"));
            return Ok(false);
        }
        storage.delete_contact(&contact)?;
        contact.id = new_id.clone();
        storage.save_contact(&contact)?;
        Ok(true)
    }

    fn name(&self, args: &[String], options: &Options) -> Result<bool> {
        let colors = self.colors("name");
        let storage = self.storage()?;
        let Some(id) = args.first() else {
            let book = storage.load_address_book()?;
            line(&format::address_book_names(&book, &colors));
            return Ok(true);
        };
        let mut contact = storage.require_contact(id)?;
        if args.get(1).is_none() && options.is_empty() {
            let name = format::name_full_only(&contact, &colors);
            if name.is_empty() {
                return Ok(false);
            }
            line(&name);
            return Ok(true);
        }
        let name = &mut contact.name;
        if let Some(full) = args.get(1) {
            name.full = full.clone();
        }
        for (key, field) in [
            ("given", &mut name.given),
            ("family", &mut name.family),
            ("middle", &mut name.middle),
            ("prefix", &mut name.prefix),
            ("suffix", &mut name.suffix),
        ] {
            if let Some(v) = options.str(key) {
                *field = v.to_string();
            }
        }
        storage.save_contact(&contact)?;
        Ok(true)
    }

    fn attribute(
        &self,
        command: &str,
        args: &[String],
        options: &Options,
        values: fn(&mut Contact) -> &mut Vec<String>,
    ) -> Result<bool> {
        let storage = self.storage()?;
        let mut colors = self.colors(command);
        match (args.first(), args.get(1)) {
            (None, _) => {
                if options.is_set("no_color") {
                    colors.clear();
                }
                let book = storage.load_address_book()?;
                line(&match command {
                    "nick" => format::address_book_nicknames(&book, &colors),
                    "org" => format::address_book_organizations(&book, &colors),
                    _ => format::address_book_urls(&book, &colors),
                });
            }
            (Some(id), None) => {
                let contact = storage.require_contact(id)?;
                line(&match command {
                    "nick" => format::contact_nicknames(&contact, &colors),
                    "org" => format::contact_organizations(&contact, &colors),
                    _ => format::contact_urls(&contact, &colors),
                });
            }
            (Some(id), Some(value)) => {
                let mut contact = storage.require_contact(id)?;
                let list = values(&mut contact);
                if options.is_set("delete") {
                    list.retain(|v| v != value);
                } else {
                    list.push(value.clone());
                }
                storage.save_contact(&contact)?;
            }
        }
        Ok(true)
    }

    fn phone(&self, args: &[String], options: &Options) -> Result<bool> {
        let storage = self.storage()?;
        let colors = self.colors("phone");
        match (args.first(), args.get(1)) {
            (None, _) => {
                let book = storage.load_address_book()?;
                line(&format::address_book_phone_numbers(&book, &colors));
            }
            (Some(id), None) => {
                let contact = storage.require_contact(id)?;
                line(&format::contact_phone_numbers(&contact, &colors));
            }
            (Some(id), Some(number)) => {
                let mut contact = storage.require_contact(id)?;
                if options.is_set("delete") {
                    contact.phone_numbers.retain(|p| &p.number != number);
                } else {
                    let exists = contact.phone_numbers.iter().any(|p| &p.number == number);
                    if !exists {
                        contact.phone_numbers.push(PhoneNumber {
                            number: number.clone(),
                            ..PhoneNumber::default()
                        });
                    }
                    let mut targets: Vec<usize> = contact
                        .phone_numbers
                        .iter()
                        .enumerate()
                        .filter(|(_, p)| &p.number == number)
                        .map(|(i, _)| i)
                        .collect();
                    if !exists {
                        targets = vec![contact.phone_numbers.len() - 1];
                    }
                    for i in targets {
                        if let Some(t) = options.str("type") {
                            contact.phone_numbers[i].kind = Some(t.to_string());
                        }
                        match options.flag("preferred") {
                            Some(true) => {
                                for p in &mut contact.phone_numbers {
                                    p.preferred = &p.number == number;
                                }
                            }
                            Some(false) => contact.phone_numbers[i].preferred = false,
                            None => {}
                        }
                    }
                }
                storage.save_contact(&contact)?;
            }
        }
        Ok(true)
    }

    fn post(&self, args: &[String], options: &Options) -> Result<bool> {
        let storage = self.storage()?;
        let Some(id) = args.first() else {
            let book = storage.load_address_book()?;
            line(&format::address_book_postal_addresses(
                &book,
                &self.colors("post"),
            ));
            return Ok(true);
        };
        let mut contact = storage.require_contact(id)?;
        let Some(address_id) = args.get(1) else {
            let output = format::contact_postal_addresses(&contact);
            if output.is_empty() {
                return Ok(false);
            }
            line(&output);
            return Ok(true);
        };

        if options.is_set("delete") {
            if !contact.postal_addresses.iter().any(|a| &a.id == address_id) {
                return Err(Error::PostalAddressNotFound(address_id.clone()));
            }
            contact.postal_addresses.retain(|a| &a.id != address_id);
            storage.save_contact(&contact)?;
            return Ok(true);
        }

        if options.is_empty() {
            let address = contact
                .postal_addresses
                .iter()
                .find(|a| &a.id == address_id)
                .ok_or_else(|| Error::PostalAddressNotFound(address_id.clone()))?;
            line(&format::postal_address_multi_line(address));
            return Ok(true);
        }

        match contact
            .postal_addresses
            .iter()
            .position(|a| &a.id == address_id)
        {
            Some(i) => {
                update_postal_address(&mut contact.postal_addresses, i, options);
                if let Some(new_id) = options.str("new_id") {
                    if contact.postal_addresses.iter().any(|a| a.id == new_id) {
                        return Err(Error::Other(format!(
                            "Address '{new_id}' is already in use"
                        )));
                    }
                    contact.postal_addresses[i].id = new_id.to_string();
                }
            }
            None => {
                contact.postal_addresses.push(PostalAddress {
                    id: address_id.clone(),
                    ..PostalAddress::default()
                });
                let i = contact.postal_addresses.len() - 1;
                update_postal_address(&mut contact.postal_addresses, i, options);
            }
        }
        storage.save_contact(&contact)?;
        Ok(true)
    }

    fn rm(&self, args: &[String]) -> Result<bool> {
        let id = args.first().ok_or_else(|| usage("No contact specified"))?;
        let storage = self.storage()?;
        let contact = storage.require_contact(id)?;
        storage.delete_contact(&contact)?;
        Ok(true)
    }

    fn scrape(&self, options: &Options) -> Result<bool> {
        let mut email = Vec::new();
        io::stdin().read_to_end(&mut email)?;
        let mut contacts = Vec::new();
        if options.is_set("sender") {
            contacts.extend(self.scrape_sender(&email)?);
        }
        for contact in contacts {
            if options.is_set("quiet") || confirm_contact(&contact)? {
                self.storage()?.save_contact(&contact)?;
            }
        }
        Ok(true)
    }

    fn scrape_sender(&self, email: &[u8]) -> Result<Option<Contact>> {
        let Some(message) = mail_parser::MessageParser::default().parse(email) else {
            return Ok(None);
        };
        let Some(from) = message.from().and_then(|f| f.first()) else {
            return Ok(None);
        };
        let address = from.address().unwrap_or_default().to_string();
        let display_name = from.name().map(String::from);
        let id = match &display_name {
            Some(name) => {
                let base = name.to_lowercase().replace(' ', "_");
                let mut id = base.clone();
                let mut suffix = 0;
                while self.storage()?.load_contact(&id)?.is_some() {
                    suffix += 1;
                    id = format!("{base}_{suffix}");
                }
                id
            }
            None => address.clone(),
        };
        Ok(Some(Contact {
            name: Name {
                full: display_name.unwrap_or_else(|| id.clone()),
                ..Name::default()
            },
            id,
            email_addresses: vec![EmailAddress::new(&address)],
            ..Contact::default()
        }))
    }

    fn shell(&self) -> Result<bool> {
        let tty = io::stdin().is_terminal();
        if tty {
            line(&format!("ppl {VERSION} (type \"exit\" to leave)"));
        }
        let prompt = if tty { "ppl> " } else { "" };
        let program = std::env::args().next().unwrap_or_else(|| "ppl".into());

        let mut editor =
            rustyline::DefaultEditor::new().map_err(|e| Error::Other(e.to_string()))?;
        let outcome = loop {
            match editor.readline(prompt) {
                Ok(input) => {
                    if input == "exit" {
                        break true;
                    }
                    let _ = editor.add_history_entry(input.as_str());
                    let _ = process::Command::new("/bin/sh")
                        .arg("-c")
                        .arg(format!("{program} {input}"))
                        .status();
                }
                Err(rustyline::error::ReadlineError::Interrupted) => break false,
                Err(_) => break true,
            }
        };
        if tty {
            line("");
        }
        Ok(outcome)
    }

    fn show(&self, args: &[String]) -> Result<bool> {
        let id = args.first().ok_or_else(|| usage("No contact specified"))?;
        let contact = self.storage()?.require_contact(id)?;
        line(&format::contact_full(&contact));
        Ok(true)
    }
}

fn update_postal_address(addresses: &mut [PostalAddress], i: usize, options: &Options) {
    let address = &mut addresses[i];
    for (key, field) in [
        ("country", &mut address.country),
        ("locality", &mut address.locality),
        ("po_box", &mut address.po_box),
        ("postal_code", &mut address.postal_code),
        ("region", &mut address.region),
        ("street", &mut address.street),
    ] {
        if let Some(v) = options.str(key) {
            *field = v.to_string();
        }
    }
    let id = address.id.clone();
    match options.flag("preferred") {
        Some(true) => {
            for a in addresses.iter_mut() {
                a.preferred = a.id == id;
            }
        }
        Some(false) => addresses[i].preferred = false,
        None => {}
    }
}

/// Asks whether to add a scraped contact, reading the answer from the
/// terminal since stdin holds the email.
fn confirm_contact(contact: &Contact) -> Result<bool> {
    let email = contact
        .email_addresses
        .first()
        .map(|e| e.address.as_str())
        .unwrap_or_default();
    print!(
        "Add \"{} <{}>\" to your address book [Y/n]? ",
        contact.name.full, email
    );
    io::stdout().flush()?;
    let tty = std::fs::File::open("/dev/tty")?;
    let mut answer = String::new();
    if io::BufReader::new(tty).read_line(&mut answer)? == 0 {
        return Err(Error::Other("undefined method 'downcase' for nil".into()));
    }
    Ok(answer.trim_end_matches(['\n', '\r']).to_lowercase() != "n")
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn routes_aliases() {
        let mut aliases = HashMap::new();
        aliases.insert("l".to_string(), Value::Str("ls".into()));
        aliases.insert("log".to_string(), Value::Str("!git log".into()));
        aliases.insert("bad".to_string(), Value::Str("nope".into()));
        aliases.insert("num".to_string(), Value::Integer("1".into()));
        let name = |a: Option<&str>| match route(a, &aliases) {
            Ok(Route::Command(c)) => c.name.to_string(),
            Ok(Route::Alias(cmd)) => format!("!{cmd}"),
            Err(e) => e.to_string(),
        };
        assert_eq!(name(Some("ls")), "ls");
        assert_eq!(name(Some("l")), "ls");
        assert_eq!(name(Some("log")), "!git log");
        assert_eq!(name(Some("bad")), "help");
        assert_eq!(name(None), "help");
        assert_eq!(
            name(Some("num")),
            "ppl: undefined method 'match' for an instance of Integer"
        );
    }
}
