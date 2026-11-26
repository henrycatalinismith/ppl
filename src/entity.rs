use chrono::{Datelike, NaiveDate};

#[derive(Clone, Debug, Default, PartialEq)]
pub struct Name {
    pub full: String,
    pub given: String,
    pub family: String,
    pub middle: String,
    pub prefix: String,
    pub suffix: String,
}

impl Name {
    /// Splits a full name into given and family names, as `ppl add` does.
    pub fn parse(full_name: &str) -> Name {
        let mut parts = full_name.split_whitespace();
        let given = parts.next().unwrap_or("").to_string();
        let family = parts.collect::<Vec<_>>().join(" ");
        Name {
            full: full_name.to_string(),
            given,
            family,
            ..Name::default()
        }
    }
}

#[derive(Clone, Debug, Default, PartialEq)]
pub struct EmailAddress {
    pub address: String,
    pub preferred: bool,
}

impl EmailAddress {
    pub fn new(address: &str) -> EmailAddress {
        EmailAddress {
            address: address.to_string(),
            preferred: false,
        }
    }
}

#[derive(Clone, Debug, Default, PartialEq)]
pub struct PhoneNumber {
    pub number: String,
    /// `None` for numbers added without a type. Numbers loaded from a vCard
    /// always have `Some`, possibly empty, which affects how they're encoded.
    pub kind: Option<String>,
    pub preferred: bool,
}

#[derive(Clone, Debug, Default, PartialEq)]
pub struct PostalAddress {
    pub id: String,
    pub preferred: bool,
    pub country: String,
    pub locality: String,
    pub street: String,
    pub po_box: String,
    pub postal_code: String,
    pub region: String,
}

#[derive(Clone, Debug, Default, PartialEq)]
pub struct Contact {
    pub id: String,
    pub name: Name,
    pub nicknames: Vec<String>,
    pub email_addresses: Vec<EmailAddress>,
    pub birthday: Option<NaiveDate>,
    pub phone_numbers: Vec<PhoneNumber>,
    pub organizations: Vec<String>,
    pub postal_addresses: Vec<PostalAddress>,
    pub urls: Vec<String>,
}

impl Contact {
    pub fn age(&self, on: NaiveDate) -> Option<i32> {
        let b = self.birthday?;
        let had_birthday =
            on.month() > b.month() || (on.month() == b.month() && on.day() >= b.day());
        Some(on.year() - b.year() - if had_birthday { 0 } else { 1 })
    }

    pub fn preferred_email_address(&self) -> Option<&EmailAddress> {
        self.email_addresses.iter().find(|e| e.preferred)
    }

    pub fn preferred_phone_number(&self) -> Option<&PhoneNumber> {
        self.phone_numbers.iter().find(|p| p.preferred)
    }

    /// The preferred email address, or the first one if none is preferred.
    pub fn main_email_address(&self) -> Option<&EmailAddress> {
        self.preferred_email_address()
            .or_else(|| self.email_addresses.first())
    }
}

#[derive(Debug, Default)]
pub struct AddressBook {
    pub contacts: Vec<Contact>,
}

#[cfg(test)]
mod tests {
    use super::*;

    fn date(y: i32, m: u32, d: u32) -> NaiveDate {
        NaiveDate::from_ymd_opt(y, m, d).unwrap()
    }

    #[test]
    fn age_before_and_after_birthday() {
        let c = Contact {
            birthday: Some(date(1980, 6, 15)),
            ..Contact::default()
        };
        assert_eq!(c.age(date(2020, 6, 14)), Some(39));
        assert_eq!(c.age(date(2020, 6, 15)), Some(40));
        assert_eq!(c.age(date(2020, 7, 1)), Some(40));
        assert_eq!(Contact::default().age(date(2020, 1, 1)), None);
    }

    #[test]
    fn parse_name() {
        let n = Name::parse("Bob Q Smith");
        assert_eq!(n.given, "Bob");
        assert_eq!(n.family, "Q Smith");
        assert_eq!(n.full, "Bob Q Smith");
        let n = Name::parse("");
        assert_eq!(n.given, "");
        assert_eq!(n.family, "");
    }
}
