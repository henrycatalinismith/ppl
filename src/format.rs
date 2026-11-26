use std::collections::HashMap;
use std::sync::LazyLock;

use chrono::NaiveDate;
use regex::Regex;

use crate::entity::{AddressBook, Contact, EmailAddress, PostalAddress};
use crate::rb;

pub type Colors = HashMap<String, String>;

const COLORS: [&str; 8] = [
    "black", "red", "green", "yellow", "blue", "magenta", "cyan", "white",
];

pub fn colorize(s: &str, color: Option<&String>) -> String {
    match color.and_then(|c| COLORS.iter().position(|n| n == c)) {
        Some(i) => format!("\x1b[{}m{s}\x1b[0m", 30 + i),
        None => s.to_string(),
    }
}

pub struct Table {
    columns: Vec<&'static str>,
    rows: Vec<Vec<String>>,
    widths: Vec<usize>,
    tabs: bool,
    colors: Colors,
}

impl Table {
    pub fn new(columns: &[&'static str], colors: &Colors) -> Table {
        Table {
            columns: columns.to_vec(),
            rows: Vec::new(),
            widths: vec![0; columns.len()],
            tabs: false,
            colors: colors.clone(),
        }
    }

    pub fn tabs(mut self) -> Table {
        self.tabs = true;
        self
    }

    pub fn add_row(&mut self, row: Vec<String>) {
        for (w, v) in self.widths.iter_mut().zip(&row) {
            *w = (*w).max(v.chars().count());
        }
        self.rows.push(row);
    }

    pub fn render(&self) -> String {
        let mut out = String::new();
        for row in &self.rows {
            let mut line = String::new();
            for (i, column) in self.columns.iter().enumerate() {
                let cell = if self.tabs {
                    format!("{}\t", row[i])
                } else {
                    format!("{}  ", rb::ljust(&row[i], self.widths[i]))
                };
                line.push_str(&colorize(&cell, self.colors.get(*column)));
            }
            out.push_str(rb::rstrip(&line));
            out.push('\n');
        }
        rb::rstrip(&out).to_string()
    }
}

fn id_cell(c: &Contact) -> String {
    format!("{}:", c.id)
}

fn date_string(d: NaiveDate) -> String {
    d.format("%Y-%m-%d").to_string()
}

/// A two-column `id: value` listing of every contact in the address book.
fn list(
    book: &AddressBook,
    column: &'static str,
    colors: &Colors,
    value: impl Fn(&Contact) -> String,
) -> String {
    let mut table = Table::new(&["id", column], colors);
    for c in &book.contacts {
        table.add_row(vec![id_cell(c), value(c)]);
    }
    table.render()
}

pub fn address_book_ages(book: &AddressBook, colors: &Colors, today: NaiveDate) -> String {
    list(book, "age", colors, |c| {
        c.age(today).map(|a| a.to_string()).unwrap_or_default()
    })
}

pub fn address_book_birthdays(book: &AddressBook, colors: &Colors) -> String {
    list(book, "birthday", colors, |c| {
        c.birthday.map(date_string).unwrap_or_default()
    })
}

pub fn address_book_email_addresses(book: &AddressBook, colors: &Colors) -> String {
    list(book, "email_addresses", colors, |c| {
        c.email_addresses
            .iter()
            .map(|e| e.address.as_str())
            .collect::<Vec<_>>()
            .join(", ")
    })
}

pub fn address_book_names(book: &AddressBook, colors: &Colors) -> String {
    list(book, "name", colors, |c| c.name.full.clone())
}

pub fn address_book_nicknames(book: &AddressBook, colors: &Colors) -> String {
    list(book, "nicknames", colors, |c| c.nicknames.join(", "))
}

pub fn address_book_organizations(book: &AddressBook, colors: &Colors) -> String {
    list(book, "organizations", colors, |c| {
        c.organizations.join(", ")
    })
}

pub fn address_book_phone_numbers(book: &AddressBook, colors: &Colors) -> String {
    list(book, "phone_numbers", colors, |c| {
        c.phone_numbers
            .iter()
            .map(|p| p.number.as_str())
            .collect::<Vec<_>>()
            .join(", ")
    })
}

pub fn address_book_postal_addresses(book: &AddressBook, colors: &Colors) -> String {
    list(book, "address_ids", colors, |c| {
        c.postal_addresses
            .iter()
            .map(|p| p.id.as_str())
            .collect::<Vec<_>>()
            .join(", ")
    })
}

pub fn address_book_urls(book: &AddressBook, colors: &Colors) -> String {
    list(book, "urls", colors, |c| c.urls.join(", "))
}

pub fn address_book_one_line(book: &AddressBook, colors: &Colors) -> String {
    let mut table = Table::new(&["id", "name", "email"], colors);
    for c in &book.contacts {
        let email = c
            .main_email_address()
            .map(|e| format!("<{}>", e.address))
            .unwrap_or_default();
        table.add_row(vec![id_cell(c), c.name.full.clone(), email]);
    }
    table.render()
}

pub fn address_book_mutt_query(book: &AddressBook) -> String {
    let mut table = Table::new(&["email", "name"], &Colors::new()).tabs();
    for c in &book.contacts {
        for e in &c.email_addresses {
            table.add_row(vec![e.address.clone(), c.name.full.clone()]);
        }
    }
    table.render()
}

fn colorize_key(s: String, colors: &Colors, key: &str) -> String {
    match colors.get(key) {
        Some(_) => colorize(&s, colors.get(key)),
        None => s,
    }
}

pub fn contact_age(c: &Contact, colors: &Colors, today: NaiveDate) -> String {
    let age = c.age(today).map(|a| a.to_string()).unwrap_or_default();
    colorize_key(age, colors, "age")
}

pub fn contact_birthday(c: &Contact, colors: &Colors) -> String {
    let b = c.birthday.map(date_string).unwrap_or_default();
    colorize_key(b, colors, "birthday")
}

pub fn contact_nicknames(c: &Contact, colors: &Colors) -> String {
    colorize_key(c.nicknames.join("\n"), colors, "nicknames")
}

pub fn contact_organizations(c: &Contact, colors: &Colors) -> String {
    colorize_key(c.organizations.join("\n"), colors, "organizations")
}

pub fn contact_urls(c: &Contact, colors: &Colors) -> String {
    colorize_key(c.urls.join("\n"), colors, "urls")
}

pub fn name_full_only(c: &Contact, colors: &Colors) -> String {
    colorize_key(c.name.full.clone(), colors, "name")
}

fn star(preferred: bool) -> String {
    if preferred { "*" } else { " " }.to_string()
}

pub fn contact_email_addresses(c: &Contact, colors: &Colors) -> String {
    let mut table = Table::new(&["star", "email_addresses"], colors);
    for e in &c.email_addresses {
        table.add_row(vec![star(e.preferred), e.address.clone()]);
    }
    table.render()
}

pub fn contact_phone_numbers(c: &Contact, colors: &Colors) -> String {
    let mut table = Table::new(&["star", "phone_numbers", "type"], colors);
    for p in &c.phone_numbers {
        let kind = match p.kind.as_deref() {
            None | Some("") => String::new(),
            Some(k) => format!("({k})"),
        };
        table.add_row(vec![star(p.preferred), p.number.clone(), kind]);
    }
    table.render()
}

fn non_empty_join(parts: &[&String], sep: &str) -> String {
    parts
        .iter()
        .filter(|p| !p.is_empty())
        .map(|p| p.as_str())
        .collect::<Vec<_>>()
        .join(sep)
}

pub fn contact_postal_addresses(c: &Contact) -> String {
    let mut table = Table::new(&["star", "address_id", "address_text"], &Colors::new());
    for a in &c.postal_addresses {
        let text = non_empty_join(
            &[
                &a.street,
                &a.locality,
                &a.region,
                &a.country,
                &a.postal_code,
                &a.po_box,
            ],
            ", ",
        );
        table.add_row(vec![star(a.preferred), a.id.clone(), text]);
    }
    table.render()
}

pub fn postal_address_multi_line(a: &PostalAddress) -> String {
    non_empty_join(
        &[
            &a.street,
            &a.locality,
            &a.region,
            &a.country,
            &a.po_box,
            &a.postal_code,
        ],
        "\n",
    )
}

pub fn contact_full(c: &Contact) -> String {
    let mut lines: Vec<String> = Vec::new();

    let mut first_line = c.name.full.clone();
    if let Some(e) = c.main_email_address() {
        first_line.push_str(&format!(" <{}>", e.address));
    }
    if !first_line.is_empty() {
        lines.push(first_line);
    }

    if let Some(b) = c.birthday {
        lines.push(String::new());
        lines.push(format!(
            "  {} {}",
            rb::ljust("Birthday", 12),
            date_string(b)
        ));
    }

    let push_list = |lines: &mut Vec<String>, label: &str, list: &[String]| {
        if list.is_empty() {
            return;
        }
        lines.push(String::new());
        lines.push(format!("{label}:"));
        for item in list {
            lines.push(format!("  {item}"));
        }
    };

    push_list(&mut lines, "Organizations", &c.organizations);

    let none = Colors::new();
    if !c.email_addresses.is_empty() {
        lines.push(String::new());
        lines.push("Email Addresses:".into());
        lines.push(contact_email_addresses(c, &none));
    }
    if !c.phone_numbers.is_empty() {
        lines.push(String::new());
        lines.push("Phone Numbers".into());
        lines.push(contact_phone_numbers(c, &none));
    }
    if !c.postal_addresses.is_empty() {
        lines.push(String::new());
        lines.push("Postal Addresses".into());
        lines.push(contact_postal_addresses(c));
    }

    push_list(&mut lines, "URLs", &c.urls);

    lines.join("\n")
}

static PIECE: LazyLock<Regex> = LazyLock::new(|| Regex::new(r"[^%]+|%-?[0-9]*.").unwrap());
static PLACEHOLDER: LazyLock<Regex> =
    LazyLock::new(|| Regex::new(r"(?i)^%(-?[0-9]+)?([a-z])$").unwrap());

/// User-defined formats such as `%i: %N`, expanded by `lookup`.
fn custom(format: &str, lookup: impl Fn(char) -> Option<String>) -> String {
    let mut out = String::new();
    for piece in PIECE.find_iter(format) {
        let piece = piece.as_str();
        let Some(caps) = PLACEHOLDER.captures(piece) else {
            out.push_str(piece);
            continue;
        };
        let letter = caps[2].chars().next().unwrap();
        let value = lookup(letter).unwrap_or_default();
        let padding: i64 = caps
            .get(1)
            .and_then(|p| p.as_str().parse().ok())
            .unwrap_or(0);
        let width = padding.unsigned_abs() as usize;
        out.push_str(&match padding {
            p if p > 0 => rb::rjust(&value, width),
            p if p < 0 => rb::ljust(&value, width),
            _ => value,
        });
    }
    out
}

pub fn custom_contact(format: &str, c: &Contact, today: NaiveDate) -> String {
    custom(format, |letter| match letter {
        'n' => Some("\n".into()),
        'i' => Some(c.id.clone()),
        'N' => Some(c.name.full.clone()),
        'a' => c.age(today).map(|a| a.to_string()),
        'b' => c.birthday.map(date_string),
        'k' => c.nicknames.first().cloned(),
        'e' => c.main_email_address().map(|e| e.address.clone()),
        'o' => c.organizations.first().cloned(),
        'p' => c
            .preferred_phone_number()
            .or_else(|| c.phone_numbers.first())
            .map(|p| p.number.clone()),
        other => Some(other.to_string()),
    })
}

pub fn custom_email_address(format: &str, e: &EmailAddress) -> String {
    custom(format, |letter| match letter {
        'a' => Some(e.address.clone()),
        'f' => e.preferred.then(|| "*".to_string()),
        other => Some(other.to_string()),
    })
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::entity::Name;

    fn contact(id: &str, name: &str, email: Option<&str>) -> Contact {
        Contact {
            id: id.into(),
            name: Name::parse(name),
            email_addresses: email.into_iter().map(EmailAddress::new).collect(),
            ..Contact::default()
        }
    }

    #[test]
    fn one_line_pads_columns() {
        let book = AddressBook {
            contacts: vec![
                contact("bob", "Bob", Some("bob@example.org")),
                contact("alice", "Alice Adams", None),
            ],
        };
        assert_eq!(
            address_book_one_line(&book, &Colors::new()),
            "bob:    Bob          <bob@example.org>\nalice:  Alice Adams"
        );
    }

    #[test]
    fn colors_cells() {
        let mut colors = Colors::new();
        colors.insert("id".into(), "red".into());
        let book = AddressBook {
            contacts: vec![contact("bob", "Bob", None)],
        };
        assert_eq!(
            address_book_names(&book, &colors),
            "\x1b[31mbob:  \x1b[0mBob"
        );
    }

    #[test]
    fn custom_formats() {
        let c = contact("bob", "Bob", Some("b@x"));
        let today = NaiveDate::from_ymd_opt(2020, 1, 1).unwrap();
        assert_eq!(
            custom_contact("%i: %N <%e>%n", &c, today),
            "bob: Bob <b@x>\n"
        );
        assert_eq!(custom_contact("[%5i|%-5i]", &c, today), "[  bob|bob  ]");
        assert_eq!(custom_contact("%z %% %a", &c, today), "z %% ");
    }
}
