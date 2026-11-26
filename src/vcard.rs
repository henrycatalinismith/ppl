//! A port of the subset of the vpim gem that ppl relies on. It reproduces
//! vpim's encoding byte for byte, and its decoding quirks, so address books
//! written by either implementation are interchangeable.

use std::sync::LazyLock;

use chrono::{Datelike, Local, NaiveDate};
use regex::Regex;
use sha1::{Digest, Sha1};

use crate::entity::{Contact, EmailAddress, Name, PhoneNumber, PostalAddress};
use crate::rb;

#[derive(Debug, PartialEq)]
pub enum VcardError {
    /// vpim's `InvalidEncodingError`.
    Invalid(String),
    /// Any other error raised while decoding.
    Other(String),
}

type Result<T> = std::result::Result<T, VcardError>;

const NAME: &str = r"[-a-z0-9_/][-a-z0-9_/ ]*";
const PVALUE: &str = r#"(?:"(?:[^"]*)"|(?:[^";:,]+))"#;
const SPACE: &str = r"[ \t\r\n\x0b\x0c]";

static LINE: LazyLock<Regex> = LazyLock::new(|| {
    let param = format!(";(?:{NAME})=?(?:{PVALUE})?(?:,{PVALUE})*");
    Regex::new(&format!(
        r"(?i)^(?P<group>(?:{NAME}\.)*)?(?P<name>{NAME})(?P<params>(?:{param})*):(?P<value>.*)$"
    ))
    .unwrap()
});

static PARAM: LazyLock<Regex> = LazyLock::new(|| {
    Regex::new(&format!(
        r"(?i);(?P<name>{NAME})(?P<eq>=?)(?P<values>(?:{PVALUE})?(?:,{PVALUE})*)"
    ))
    .unwrap()
});

static PVALUE_CAPTURE: LazyLock<Regex> =
    LazyLock::new(|| Regex::new(r#""([^"]*)"|([^";:,]+)"#).unwrap());

static DATE: LazyLock<Regex> = LazyLock::new(|| {
    Regex::new(&format!(
        r"^{SPACE}*([0-9]{{4}})-?([0-9]{{2}})-?([0-9]{{2}}){SPACE}*$"
    ))
    .unwrap()
});

static DATE_TIME: LazyLock<Regex> = LazyLock::new(|| {
    Regex::new(&format!(
        r"^{SPACE}*([0-9]{{4}})-?([0-9]{{2}})-?([0-9]{{2}})T([0-9]{{2}}):?([0-9]{{2}}):?([0-9]{{2}})(\.[0-9]+)?(Z|[-+][0-9]{{2}}:?[0-9]{{2}})?{SPACE}*$"
    ))
    .unwrap()
});

static LOOSE_DATE: LazyLock<Regex> = LazyLock::new(|| {
    Regex::new(&format!(r"^{SPACE}*([0-9]+)-([0-9]+)-([0-9]+){SPACE}*$")).unwrap()
});

#[derive(Clone, Debug)]
struct Field {
    name: String,
    params: Vec<(String, Vec<String>)>,
    value: String,
}

impl Field {
    fn decode(line: &str) -> Result<Field> {
        let caps = LINE
            .captures(line)
            .ok_or_else(|| VcardError::Invalid(line.to_string()))?;
        let name = caps["name"].to_uppercase();
        let paramslist = &caps["params"];
        let value = rb::strip(&caps["value"]).to_string();

        let mut params: Vec<(String, Vec<String>)> = Vec::new();
        if paramslist.len() > 1 {
            for p in PARAM.captures_iter(paramslist) {
                let raw_name = &p["name"];
                let (pname, values) = if p["eq"].is_empty() {
                    let lower = raw_name.to_lowercase();
                    let pname = if lower.contains("quoted-printable") || lower.contains("base64") {
                        "ENCODING"
                    } else {
                        "TYPE"
                    };
                    (pname.to_string(), raw_name)
                } else {
                    (raw_name.to_uppercase(), &p["values"])
                };
                let idx = match params.iter().position(|(n, _)| *n == pname) {
                    Some(i) => i,
                    None => {
                        params.push((pname, Vec::new()));
                        params.len() - 1
                    }
                };
                for v in PVALUE_CAPTURE.captures_iter(values) {
                    let v = v.get(1).or_else(|| v.get(2)).unwrap().as_str();
                    params[idx].1.push(v.to_string());
                }
            }
        }

        Ok(Field {
            name,
            params,
            value,
        })
    }

    fn is(&self, name: &str) -> bool {
        self.name.eq_ignore_ascii_case(name)
    }

    fn param(&self, name: &str) -> Option<&Vec<String>> {
        self.params.iter().find(|(n, _)| n == name).map(|(_, v)| v)
    }

    fn types(&self) -> Vec<String> {
        self.param("TYPE")
            .map(|v| v.iter().map(|t| t.to_lowercase()).collect())
            .unwrap_or_default()
    }

    fn is_pref(&self) -> bool {
        self.param("TYPE")
            .is_some_and(|v| v.iter().any(|t| t.eq_ignore_ascii_case("pref")))
    }

    /// The value with any `ENCODING` applied.
    fn value(&self) -> Result<String> {
        let encoding = match self.param("ENCODING") {
            None => None,
            Some(e) if e.len() > 1 => {
                return Err(VcardError::Invalid(format!(
                    "multi-valued param 'ENCODING' ({})",
                    e.join(", ")
                )))
            }
            Some(e) => e.first().map(|e| e.to_uppercase()),
        };
        match encoding.as_deref() {
            None | Some("8BIT") | Some("7BIT") => Ok(self.value.clone()),
            Some("B") | Some("BASE64") => Ok(String::from_utf8_lossy(&decode_base64(
                &self.value.replace(' ', ""),
            ))
            .into_owned()),
            Some("QUOTED-PRINTABLE") => {
                Ok(String::from_utf8_lossy(&decode_quoted_printable(&self.value)).into_owned())
            }
            Some(e) => Err(VcardError::Invalid(format!("unrecognized encoding ({e})"))),
        }
    }
}

fn decode_base64(s: &str) -> Vec<u8> {
    let mut out = Vec::new();
    let mut buf = 0u32;
    let mut bits = 0;
    for c in s.bytes() {
        let v = match c {
            b'A'..=b'Z' => c - b'A',
            b'a'..=b'z' => c - b'a' + 26,
            b'0'..=b'9' => c - b'0' + 52,
            b'+' => 62,
            b'/' => 63,
            b'=' => break,
            _ => continue,
        };
        buf = (buf << 6) | v as u32;
        bits += 6;
        if bits >= 8 {
            bits -= 8;
            out.push((buf >> bits) as u8);
            buf &= (1 << bits) - 1;
        }
    }
    out
}

fn decode_quoted_printable(s: &str) -> Vec<u8> {
    let bytes = s.as_bytes();
    let mut out = Vec::new();
    let mut i = 0;
    while i < bytes.len() {
        if bytes[i] == b'=' {
            if bytes.get(i + 1) == Some(&b'\n') {
                i += 2;
                continue;
            }
            if bytes.get(i + 1) == Some(&b'\r') && bytes.get(i + 2) == Some(&b'\n') {
                i += 3;
                continue;
            }
            let hex = |b: Option<&u8>| b.and_then(|b| (*b as char).to_digit(16));
            if let (Some(h), Some(l)) = (hex(bytes.get(i + 1)), hex(bytes.get(i + 2))) {
                out.push((h * 16 + l) as u8);
                i += 3;
                continue;
            }
        }
        out.push(bytes[i]);
        i += 1;
    }
    out
}

fn decode_text(v: &str) -> String {
    let mut out = String::new();
    let mut chars = v.chars();
    while let Some(c) = chars.next() {
        if c == '\\' {
            match chars.clone().next() {
                Some('\n') | None => out.push(c),
                Some(n) => {
                    chars.next();
                    out.push(if n == 'n' || n == 'N' { '\n' } else { n });
                }
            }
        } else {
            out.push(c);
        }
    }
    out
}

fn encode_text(v: &str) -> String {
    let mut out = String::new();
    for c in v.chars() {
        match c {
            '\\' | ',' | ';' => {
                out.push('\\');
                out.push(c);
            }
            '\n' => out.push_str("\\n"),
            _ => out.push(c),
        }
    }
    out
}

/// vpim's `decode_text_list`. Every item except the last is unescaped.
fn decode_text_list(value: &str, sep: char) -> Vec<String> {
    let sep = regex::escape(&sep.to_string());
    let item = format!(r"([^{sep}\\]*(?:\\.[^{sep}\\]*)*)");
    let scan = Regex::new(&format!("{item}{sep}")).unwrap();
    let last = Regex::new(&format!("{item}$")).unwrap();
    let mut list: Vec<String> = scan
        .captures_iter(value)
        .map(|c| decode_text(&c[1]))
        .collect();
    if let Some(c) = last.captures(value) {
        list.push(c[1].to_string());
    }
    list
}

fn unfold(card: &str) -> Vec<String> {
    let mut unfolded: Vec<String> = Vec::new();
    for line in card.split_inclusive('\n') {
        let line = line
            .strip_suffix("\r\n")
            .or_else(|| line.strip_suffix('\n'))
            .or_else(|| line.strip_suffix('\r'))
            .unwrap_or(line);
        let qp_continuation = unfolded.last().is_some_and(|l| {
            l.ends_with('=')
                && l.find(";ENCODING=QUOTED-PRINTABLE:")
                    .is_some_and(|i| i + ";ENCODING=QUOTED-PRINTABLE:".len() < l.len())
        });
        if line.starts_with([' ', '\t']) && !unfolded.is_empty() {
            unfolded.last_mut().unwrap().push_str(&line[1..]);
        } else if qp_continuation {
            unfolded.last_mut().unwrap().push_str(line);
        } else if line.is_empty() {
        } else {
            unfolded.push(line.to_string());
        }
    }
    unfolded
}

fn to_text(bytes: &[u8]) -> String {
    let utf16 = |bytes: &[u8], be: bool| -> String {
        let units: Vec<u16> = bytes
            .as_chunks::<2>()
            .0
            .iter()
            .map(|c| {
                if be {
                    u16::from_be_bytes([c[0], c[1]])
                } else {
                    u16::from_le_bytes([c[0], c[1]])
                }
            })
            .collect();
        String::from_utf16_lossy(&units)
    };
    match bytes {
        [0xEF, 0xBB, 0xBF, rest @ ..] => String::from_utf8_lossy(rest).into_owned(),
        [0xFE, 0xFF, rest @ ..] => utf16(rest, true),
        [0xFF, 0xFE, rest @ ..] => utf16(rest, false),
        [0x00, b'B' | b'b', ..] => utf16(bytes, true),
        [b'B' | b'b', 0x00, ..] => utf16(bytes, false),
        _ => String::from_utf8_lossy(bytes).into_owned(),
    }
}

struct Card {
    fields: Vec<Field>,
}

impl Card {
    /// Decodes the first vCard in `bytes`, like `Vpim::Vcard.decode(s).first`.
    fn decode(bytes: &[u8]) -> Result<Option<Card>> {
        let text = to_text(bytes);
        let fields = unfold(&text)
            .iter()
            .map(|l| Field::decode(l))
            .collect::<Result<Vec<_>>>()?;

        let mut entities: Vec<Vec<Field>> = Vec::new();
        let mut stack: Vec<String> = Vec::new();
        let mut stray = false;
        for f in fields {
            if f.is("BEGIN") {
                if stack.is_empty() {
                    entities.push(Vec::new());
                }
                stack.push(f.value()?);
                entities.last_mut().unwrap().push(f);
            } else if f.is("END") {
                let Some(begin) = stack.pop() else {
                    return Err(VcardError::Other("Not a valid vCard".into()));
                };
                let end = f.value()?;
                if !begin.eq_ignore_ascii_case(&end) {
                    return Err(VcardError::Other(format!(
                        "BEGIN/END mismatch ({begin} != {end})"
                    )));
                }
                entities.last_mut().unwrap().push(f);
            } else if stack.is_empty() {
                stray = true;
            } else {
                entities.last_mut().unwrap().push(f);
            }
        }
        if stray {
            return Err(VcardError::Other("Not a valid vCard".into()));
        }

        let Some(fields) = entities.into_iter().next() else {
            return Ok(None);
        };
        let last = fields.last().unwrap();
        if !last.is("END") {
            return Err(VcardError::Other(format!(
                "Needs END, found: {}:{}",
                last.name, last.value
            )));
        }
        if !fields[0].value()?.eq_ignore_ascii_case("VCARD") {
            return Err(VcardError::Other("Mismatched profile".into()));
        }
        Ok(Some(Card { fields }))
    }

    fn named<'a>(&'a self, name: &'a str) -> impl Iterator<Item = &'a Field> + 'a {
        self.fields.iter().filter(move |f| f.is(name))
    }

    /// Picks the field `Vcard#value` would use: valued fields over empty
    /// ones, then preferred fields over the rest.
    fn pick<'a>(&'a self, name: &'a str) -> Result<Option<&'a Field>> {
        let mut fields: Vec<&Field> = self.named(name).collect();
        let mut valued = Vec::new();
        for f in &fields {
            if !f.value()?.is_empty() {
                valued.push(*f);
            }
        }
        if !valued.is_empty() {
            fields = valued;
        }
        let pref: Vec<&Field> = fields.iter().copied().filter(|f| f.is_pref()).collect();
        if !pref.is_empty() {
            fields = pref;
        }
        Ok(fields.first().copied())
    }

    fn birthday(&self) -> Result<Option<NaiveDate>> {
        let Some(f) = self.pick("BDAY")? else {
            return Ok(None);
        };
        rescue(decode_bday(f))
    }

    fn name(&self) -> Result<Name> {
        let n = self
            .pick("N")?
            .ok_or_else(|| VcardError::Invalid("Missing mandatory N field".into()))?;
        let parts = decode_text_list(&n.value()?, ';');
        let part = |i: usize| parts.get(i).cloned().unwrap_or_default();
        let full = match self.pick("FN")? {
            Some(f) => rb::strip(&f.value()?).to_string(),
            None => String::new(),
        };
        Ok(Name {
            full,
            family: part(0),
            given: part(1),
            middle: part(2),
            prefix: part(3),
            suffix: part(4),
        })
    }

    fn emails(&self) -> Vec<EmailAddress> {
        self.named("EMAIL")
            .filter_map(|f| {
                let value = decode_text(&f.value().ok()?);
                let address = rb::strip(&value);
                if address.is_empty() {
                    return None;
                }
                Some(EmailAddress {
                    address: address.to_string(),
                    preferred: f.types().iter().any(|t| t == "pref"),
                })
            })
            .collect()
    }

    fn telephones(&self) -> Vec<PhoneNumber> {
        self.named("TEL")
            .filter_map(|f| {
                let value = decode_text(&f.value().ok()?);
                let number = rb::strip(&value);
                if number.is_empty() {
                    return None;
                }
                let mut location: Vec<String> = Vec::new();
                let mut nonstandard: Vec<String> = Vec::new();
                let mut preferred = false;
                for t in f.types() {
                    match t.as_str() {
                        "home" | "work" | "cell" | "car" | "pager" => push_uniq(&mut location, t),
                        "voice" | "fax" | "video" | "msg" | "bbs" | "modem" | "isdn" | "pcs" => {}
                        "pref" => preferred = true,
                        _ => push_uniq(&mut nonstandard, t),
                    }
                }
                for t in nonstandard {
                    push_uniq(&mut location, t);
                }
                Some(PhoneNumber {
                    number: number.to_string(),
                    kind: Some(location.concat()),
                    preferred,
                })
            })
            .collect()
    }

    fn addresses(&self) -> Vec<PostalAddress> {
        self.named("ADR")
            .map(|f| {
                let parts = decode_text_list(&f.value, ';');
                let part = |i: usize| parts.get(i).cloned().unwrap_or_default();
                let mut location: Vec<String> = Vec::new();
                let mut delivery: Vec<String> = Vec::new();
                let mut nonstandard: Vec<String> = Vec::new();
                let mut preferred = false;
                for t in f.types() {
                    match t.as_str() {
                        "home" | "work" => push_uniq(&mut location, t),
                        "postal" | "parcel" | "dom" | "intl" => push_uniq(&mut delivery, t),
                        "pref" => preferred = true,
                        _ => push_uniq(&mut nonstandard, t),
                    }
                }
                for t in nonstandard {
                    push_uniq(&mut location, t);
                }
                let mut address = PostalAddress {
                    id: location.concat(),
                    preferred,
                    po_box: part(0),
                    street: part(2),
                    locality: part(3),
                    region: part(4),
                    postal_code: part(5),
                    country: part(6),
                };
                if address.id.is_empty() {
                    let hashed = [
                        address.country.as_str(),
                        &delivery.concat(),
                        &address.locality,
                        &address.po_box,
                        &address.postal_code,
                        &address.region,
                        &address.street,
                    ]
                    .concat();
                    let digest = Sha1::digest(hashed.as_bytes());
                    let hex: String = digest.iter().map(|b| format!("{b:02x}")).collect();
                    address.id = hex[..7].to_string();
                }
                address
            })
            .collect()
    }

    fn nicknames(&self) -> Vec<String> {
        let mut all: Vec<String> = Vec::new();
        for f in self.named("NICKNAME") {
            for n in decode_text_list(&f.value, ',') {
                if !n.is_empty() {
                    push_uniq(&mut all, n);
                }
            }
        }
        match all.first() {
            Some(first) => rb::split_drop_trailing(first, ";")
                .into_iter()
                .map(String::from)
                .collect(),
            None => Vec::new(),
        }
    }

    fn organizations(&self) -> Result<Vec<String>> {
        Ok(match self.pick("ORG")? {
            Some(f) => decode_text_list(&f.value, ';'),
            None => Vec::new(),
        })
    }

    fn urls(&self) -> Vec<String> {
        self.named("URL").filter_map(|f| f.value().ok()).collect()
    }
}

fn push_uniq(list: &mut Vec<String>, item: String) {
    if !list.contains(&item) {
        list.push(item);
    }
}

/// Turns an `InvalidEncodingError` into `nil`, as vpim's accessors do.
fn rescue<T>(r: Result<T>) -> Result<Option<T>> {
    match r {
        Ok(v) => Ok(Some(v)),
        Err(VcardError::Invalid(_)) => Ok(None),
        Err(e) => Err(e),
    }
}

fn make_date(y: i32, m: u32, d: u32) -> Result<NaiveDate> {
    NaiveDate::from_ymd_opt(y, m, d).ok_or_else(|| VcardError::Other("invalid date".into()))
}

fn decode_bday(f: &Field) -> Result<NaiveDate> {
    if let Some(c) = DATE.captures(&f.value) {
        return make_date(
            c[1].parse().unwrap(),
            c[2].parse().unwrap(),
            c[3].parse().unwrap(),
        );
    }
    if let Some(c) = DATE_TIME.captures(&f.value) {
        let n = |i: usize| c[i].parse::<u32>().unwrap();
        if n(4) > 23 || n(5) > 59 || n(6) > 59 {
            return Err(VcardError::Other("invalid date".into()));
        }
        return make_date(c[1].parse().unwrap(), n(2), n(3));
    }
    if let Some(c) = LOOSE_DATE.captures(&f.value()?) {
        let mut y: i32 = c[1].parse().unwrap_or(i32::MAX);
        if y < 1900 {
            y = Local::now().year();
        }
        return make_date(y, c[2].parse().unwrap_or(0), c[3].parse().unwrap_or(0));
    }
    Err(VcardError::Invalid(format!(
        "date-time '{}' not valid",
        f.value
    )))
}

pub fn decode(bytes: &[u8]) -> Result<Contact> {
    let card = Card::decode(bytes)?
        .ok_or_else(|| VcardError::Other("undefined method 'birthday' for nil".into()))?;
    let birthday = card.birthday()?;
    let email_addresses = card.emails();
    let phone_numbers = card.telephones();
    let postal_addresses = card.addresses();
    let nicknames = card.nicknames();
    let organizations = card.organizations()?;
    let name = card.name()?;
    let urls = card.urls();
    Ok(Contact {
        id: String::new(),
        name,
        nicknames,
        email_addresses,
        birthday,
        phone_numbers,
        organizations,
        postal_addresses,
        urls,
    })
}

fn type_param(types: Vec<String>) -> String {
    let mut uniq: Vec<String> = Vec::new();
    for t in types {
        push_uniq(&mut uniq, t.to_lowercase());
    }
    if uniq.is_empty() {
        String::new()
    } else {
        format!(";TYPE={}", uniq.join(","))
    }
}

/// vpim's `Vcard::Name#formatted`.
fn formatted(prefix: &str, given: &str, middle: &str, family: &str, suffix: &str) -> String {
    let mut f = [prefix, given, middle, family]
        .iter()
        .filter(|p| !p.is_empty())
        .map(|p| rb::strip(p))
        .collect::<Vec<_>>()
        .join(" ");
    if !suffix.is_empty() {
        f.push_str(", ");
        f.push_str(suffix);
    }
    f
}

/// Folds a content line every 75 characters, like vpim's `Field#encode`.
fn fold(line: &str) -> String {
    let mut out = String::new();
    for (i, segment) in line.split('\n').enumerate() {
        if i > 0 {
            out.push('\n');
        }
        let chars: Vec<char> = segment.chars().collect();
        let (chunks, remainder) = chars.as_chunks::<75>();
        for chunk in chunks {
            out.extend(chunk);
            out.push_str("\n ");
        }
        out.extend(remainder);
    }
    let trimmed = out.trim_end_matches([' ', '\t', '\r', '\n', '\x0b', '\x0c']);
    format!("{trimmed}\n")
}

pub fn encode(c: &Contact) -> std::result::Result<String, String> {
    let mut lines: Vec<String> = vec!["BEGIN:VCARD".into(), "VERSION:3.0".into()];

    if let Some(b) = c.birthday {
        lines.push(format!(
            "BDAY:{:04}{:02}{:02}",
            b.year(),
            b.month(),
            b.day()
        ));
    }

    let n = &c.name;
    let parts: Vec<&str> = [&n.family, &n.given, &n.middle, &n.prefix, &n.suffix]
        .iter()
        .map(|p| rb::strip(p))
        .collect();
    lines.push(format!(
        "N:{}",
        parts
            .iter()
            .map(|p| encode_text(p))
            .collect::<Vec<_>>()
            .join(";")
    ));
    let mut full_name = rb::strip(&n.full).to_string();
    if full_name.is_empty() {
        full_name = formatted(&n.prefix, &n.given, &n.middle, &n.family, &n.suffix);
    }
    let late_full_name = rb::strip(&full_name).is_empty();
    if !late_full_name {
        lines.push(format!("FN:{full_name}"));
    }

    for e in &c.email_addresses {
        let address = rb::strip(&e.address);
        if address.is_empty() {
            return Err("EMAIL must have a value".into());
        }
        let types = if e.preferred {
            vec!["pref".to_string()]
        } else {
            vec![]
        };
        lines.push(format!("EMAIL{}:{address}", type_param(types)));
    }

    for p in &c.phone_numbers {
        let number = rb::strip(&p.number);
        if number.is_empty() {
            return Err("TEL must have a value".into());
        }
        let mut types: Vec<String> = p.kind.iter().cloned().collect();
        if p.preferred {
            types.push("pref".into());
        }
        lines.push(format!("TEL{}:{number}", type_param(types)));
    }

    lines.push(format!("NICKNAME:{}", c.nicknames.join(";")));

    if !c.organizations.is_empty() {
        lines.push(format!("ORG:{}", c.organizations.join(";")));
    }

    for a in &c.postal_addresses {
        let mut types = vec![a.id.clone()];
        if a.preferred {
            types.push("pref".into());
        }
        let value = [
            &a.po_box,
            "",
            &a.street,
            &a.locality,
            &a.region,
            &a.postal_code,
            &a.country,
        ]
        .iter()
        .map(|p| encode_text(p))
        .collect::<Vec<_>>()
        .join(";");
        lines.push(format!("ADR{}:{value}", type_param(types)));
    }

    for u in &c.urls {
        lines.push(format!("URL:{u}"));
    }

    if late_full_name {
        lines.push(format!(
            "FN:{}",
            formatted(parts[3], parts[1], parts[2], parts[0], parts[4])
        ));
    }

    lines.push("END:VCARD".into());

    let mut out = String::new();
    for line in &lines {
        if !LINE.is_match(line.split('\n').next().unwrap()) {
            return Err(line.clone());
        }
        out.push_str(&fold(line));
    }
    Ok(out)
}

#[cfg(test)]
mod tests {
    use super::*;

    fn date(y: i32, m: u32, d: u32) -> NaiveDate {
        NaiveDate::from_ymd_opt(y, m, d).unwrap()
    }

    #[test]
    fn encodes_like_vpim() {
        let contact = Contact {
            id: "bob".into(),
            name: Name {
                full: "Bob Q Smith".into(),
                given: "Bob".into(),
                family: "Q Smith".into(),
                ..Name::default()
            },
            birthday: Some(date(1980, 2, 3)),
            email_addresses: vec![
                EmailAddress::new("b@x.org"),
                EmailAddress {
                    address: "c@x.org".into(),
                    preferred: true,
                },
            ],
            phone_numbers: vec![PhoneNumber {
                number: "0123".into(),
                kind: Some("cell".into()),
                preferred: false,
            }],
            nicknames: vec!["bobby".into(), "bo".into()],
            organizations: vec!["Acme".into()],
            postal_addresses: vec![PostalAddress {
                id: "home".into(),
                street: "1 A St".into(),
                postal_code: "AB1".into(),
                country: "UK".into(),
                ..PostalAddress::default()
            }],
            urls: vec!["http://x".into()],
        };
        let expected = "BEGIN:VCARD\nVERSION:3.0\nBDAY:19800203\nN:Q Smith;Bob;;;\n\
            FN:Bob Q Smith\nEMAIL:b@x.org\nEMAIL;TYPE=pref:c@x.org\nTEL;TYPE=cell:0123\n\
            NICKNAME:bobby;bo\nORG:Acme\nADR;TYPE=home:;;1 A St;;;AB1;UK\nURL:http://x\n\
            END:VCARD\n";
        assert_eq!(encode(&contact).unwrap(), expected);

        let mut decoded = decode(expected.as_bytes()).unwrap();
        decoded.id = "bob".into();
        for p in &mut decoded.phone_numbers {
            assert_eq!(p.kind.as_deref(), Some("cell"));
        }
        assert_eq!(decoded.name.full, contact.name.full);
        assert_eq!(decoded.email_addresses, contact.email_addresses);
        assert_eq!(decoded.nicknames, contact.nicknames);
        assert_eq!(decoded.postal_addresses, contact.postal_addresses);
        assert_eq!(encode(&decoded).unwrap(), expected);
    }

    #[test]
    fn untyped_phone_numbers_gain_an_empty_type_after_loading() {
        let card = "BEGIN:VCARD\nVERSION:3.0\nN:;Bob;;;\nFN:Bob\nTEL:123\nEND:VCARD\n";
        let contact = decode(card.as_bytes()).unwrap();
        assert!(encode(&contact).unwrap().contains("TEL;TYPE=:123\n"));
    }

    #[test]
    fn folds_long_lines() {
        let line = format!("URL:{}", "a".repeat(146));
        assert_eq!(
            fold(&line),
            format!("URL:{}\n {}\n", "a".repeat(71), "a".repeat(75))
        );
    }

    #[test]
    fn decodes_text_lists_like_vpim() {
        assert_eq!(
            decode_text_list("a\\,b;c;d\\,e", ';'),
            vec!["a,b", "c", "d\\,e"]
        );
        assert_eq!(decode_text_list("", ';'), vec![""]);
        assert_eq!(decode_text_list("a;b;", ';'), vec!["a", "b", ""]);
    }

    #[test]
    fn missing_n_is_invalid() {
        let card = "BEGIN:VCARD\nVERSION:3.0\nFN:Bob\nEND:VCARD\n";
        assert_eq!(
            decode(card.as_bytes()),
            Err(VcardError::Invalid("Missing mandatory N field".into()))
        );
    }

    #[test]
    fn hashes_unlabelled_addresses() {
        let card = "BEGIN:VCARD\nVERSION:3.0\nN:;Bob;;;\nADR:;;1 A St;;;;\nEND:VCARD\n";
        let contact = decode(card.as_bytes()).unwrap();
        assert_eq!(contact.postal_addresses[0].id.len(), 7);
    }
}
