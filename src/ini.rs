//! A port of the parts of the inifile gem used to read `~/.pplconfig`.

use std::collections::HashMap;
use std::sync::LazyLock;

use regex::Regex;

#[derive(Clone, Debug, PartialEq)]
pub enum Value {
    Bool(bool),
    Nil,
    Str(String),
    /// Values that inifile converts with Ruby's `Integer()` or `Float()`.
    Integer(String),
    Float(String),
}

impl Value {
    pub fn as_str(&self) -> Option<&str> {
        match self {
            Value::Str(s) => Some(s),
            _ => None,
        }
    }

    /// How Ruby describes the value in a `NoMethodError` message.
    pub fn ruby_description(&self) -> String {
        match self {
            Value::Bool(b) => b.to_string(),
            Value::Nil => "nil".into(),
            Value::Str(_) => "an instance of String".into(),
            Value::Integer(_) => "an instance of Integer".into(),
            Value::Float(_) => "an instance of Float".into(),
        }
    }

    /// The class name used in Ruby's `TypeError` messages.
    pub fn ruby_class(&self) -> String {
        match self {
            Value::Bool(b) => b.to_string(),
            Value::Nil => "nil".into(),
            Value::Str(_) => "String".into(),
            Value::Integer(_) => "Integer".into(),
            Value::Float(_) => "Float".into(),
        }
    }
}

static INTEGER: LazyLock<Regex> = LazyLock::new(|| {
    Regex::new(
        r"^\s*[-+]?(?:0[bB][01]+(?:_[01]+)*|0[oO]?[0-7]+(?:_[0-7]+)*|0[xX][0-9a-fA-F]+(?:_[0-9a-fA-F]+)*|0[dD][0-9]+(?:_[0-9]+)*|[1-9][0-9]*(?:_[0-9]+)*|0)\s*$",
    )
    .unwrap()
});

static FLOAT: LazyLock<Regex> = LazyLock::new(|| {
    Regex::new(r"^\s*[-+]?[0-9]+(?:_[0-9]+)*(?:\.[0-9]+(?:_[0-9]+)*)?(?:[eE][-+]?[0-9]+)?\s*$")
        .unwrap()
});

pub type Section = HashMap<String, Value>;

#[derive(Debug, Default)]
pub struct Ini {
    pub sections: HashMap<String, Section>,
}

const COMMENT: &str = r"\s*(?:[;#].*)?$";

static SECTION: LazyLock<Regex> =
    LazyLock::new(|| Regex::new(&format!(r"^\s*\[([^\]]+)\]{COMMENT}")).unwrap());
static IGNORE: LazyLock<Regex> = LazyLock::new(|| Regex::new(&format!("^{COMMENT}")).unwrap());
static FULL_QUOTE: LazyLock<Regex> =
    LazyLock::new(|| Regex::new(&format!(r#"^\s*(".*"){COMMENT}"#)).unwrap());
static OPEN_QUOTE: LazyLock<Regex> = LazyLock::new(|| Regex::new(r#"^\s*(".*)$"#).unwrap());
static CLOSE_QUOTE: LazyLock<Regex> =
    LazyLock::new(|| Regex::new(&format!(r#"^(.*"){COMMENT}"#)).unwrap());
static TRAILING_SLASH: LazyLock<Regex> =
    LazyLock::new(|| Regex::new(&format!(r"^(.*)\\{COMMENT}")).unwrap());
static NORMAL_VALUE: LazyLock<Regex> =
    LazyLock::new(|| Regex::new(&format!(r"^(.*?){COMMENT}")).unwrap());

/// Whether the character at `idx` is preceded by a backslash, emulating the
/// `(?<!\\)` lookbehinds in inifile's regular expressions.
fn escaped(s: &str, idx: usize) -> bool {
    s[..idx].ends_with('\\')
}

fn typecast(value: &str) -> Value {
    if value.eq_ignore_ascii_case("true") {
        Value::Bool(true)
    } else if value.eq_ignore_ascii_case("false") {
        Value::Bool(false)
    } else if value.trim().is_empty() {
        Value::Nil
    } else if INTEGER.is_match(value) {
        Value::Integer(value.to_string())
    } else if FLOAT.is_match(value) {
        Value::Float(value.to_string())
    } else {
        let mut out = String::new();
        let mut chars = value.chars().peekable();
        while let Some(c) = chars.next() {
            if c == '\\' {
                let replacement = match chars.peek() {
                    Some('0') => Some('\0'),
                    Some('n') => Some('\n'),
                    Some('r') => Some('\r'),
                    Some('t') => Some('\t'),
                    Some('\\') => Some('\\'),
                    _ => None,
                };
                if let Some(r) = replacement {
                    chars.next();
                    out.push(r);
                    continue;
                }
            }
            out.push(c);
        }
        Value::Str(out)
    }
}

impl Ini {
    pub fn parse(content: &str) -> Result<Ini, String> {
        let mut ini = Ini::default();
        let mut section = "global".to_string();
        let mut property: Option<String> = None;
        let mut value: Option<String> = None;
        let mut continuation = false;

        let error = |line: &str| format!("Could not parse line: {line:?}");

        let finish = |ini: &mut Ini,
                      section: &str,
                      property: &mut Option<String>,
                      value: &mut Option<String>| {
            let p = property.take().unwrap_or_default();
            let v = value.take().unwrap_or_default();
            let p = p.trim().to_string();
            let mut v = v.trim().to_string();
            if v.len() >= 2 && v.starts_with('"') && v.ends_with('"') && !escaped(&v, v.len() - 1) {
                v = v[1..v.len() - 1].to_string();
            }
            ini.sections
                .entry(section.to_string())
                .or_default()
                .insert(p, typecast(&v));
        };

        for raw in content.split_inclusive('\n') {
            let line = raw.strip_suffix('\n').unwrap_or(raw);
            let line = line.strip_suffix('\r').unwrap_or(line);

            let string: &str;
            if continuation {
                string = line;
            } else if IGNORE.is_match(line) {
                continue;
            } else if let Some(c) = SECTION.captures(line) {
                section = c[1].to_string();
                ini.sections.entry(section.clone()).or_default();
                continue;
            } else {
                let eq = line
                    .char_indices()
                    .find(|(i, c)| *c == '=' && !escaped(line, *i))
                    .map(|(i, _)| i);
                let Some(eq) = eq else {
                    return Err(error(line));
                };
                let p = line[..eq].trim();
                if p.is_empty() {
                    return Err(error(line));
                }
                property = Some(p.to_string());
                string = &line[eq + 1..];
            }

            continuation = false;
            let leading_quote = value.as_deref().is_some_and(|v| v.starts_with('"'));
            if leading_quote {
                match CLOSE_QUOTE.captures(string) {
                    Some(c) if !escaped(string, c.get(1).unwrap().end() - 1) => {
                        value.as_mut().unwrap().push_str(&c[1]);
                    }
                    _ => {
                        value.as_mut().unwrap().push_str(string);
                        continuation = true;
                    }
                }
            } else if let Some(c) = FULL_QUOTE
                .captures(string)
                .filter(|c| !escaped(string, c.get(1).unwrap().end() - 1))
            {
                value = Some(c[1].to_string());
            } else if let Some(c) = OPEN_QUOTE.captures(string) {
                value = Some(c[1].to_string());
                continuation = true;
            } else if let Some(c) = TRAILING_SLASH
                .captures(string)
                .filter(|c| !escaped(string, c.get(1).unwrap().end()))
            {
                value.get_or_insert_with(String::new).push_str(&c[1]);
                continuation = true;
            } else if let Some(c) = NORMAL_VALUE.captures(string) {
                value.get_or_insert_with(String::new).push_str(&c[1]);
            } else {
                return Err(error(line));
            }

            if continuation {
                if value.as_deref().is_some_and(|v| v.starts_with('"')) {
                    value.as_mut().unwrap().push('\n');
                }
            } else {
                finish(&mut ini, &section, &mut property, &mut value);
            }
        }

        if value.as_deref().is_some_and(|v| v.starts_with('"')) {
            return Err("Unmatched open quote".into());
        } else if property.is_some() && value.is_some() {
            finish(&mut ini, &section, &mut property, &mut value);
        }
        Ok(ini)
    }

    pub fn get(&self, section: &str, key: &str) -> Option<&Value> {
        self.sections.get(section)?.get(key)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parses_sections_and_values() {
        let ini = Ini::parse(
            "[address book]\npath = ~/contacts ; comment\n\n[color \"ls\"]\nid = blue\n\
             [color]\nls = true\n[alias]\nlog = !git log\nq = \"quoted\"\n",
        )
        .unwrap();
        assert_eq!(
            ini.get("address book", "path"),
            Some(&Value::Str("~/contacts".into()))
        );
        assert_eq!(
            ini.get("color \"ls\"", "id"),
            Some(&Value::Str("blue".into()))
        );
        assert_eq!(ini.get("color", "ls"), Some(&Value::Bool(true)));
        assert_eq!(
            ini.get("alias", "log"),
            Some(&Value::Str("!git log".into()))
        );
        assert_eq!(ini.get("alias", "q"), Some(&Value::Str("quoted".into())));
    }

    #[test]
    fn typecasts_numbers() {
        let ini = Ini::parse("a = 42\nb = 0x1f\nc = 1.5e3\nd = 08\ne = 1a\n").unwrap();
        assert_eq!(ini.get("global", "a"), Some(&Value::Integer("42".into())));
        assert_eq!(ini.get("global", "b"), Some(&Value::Integer("0x1f".into())));
        assert_eq!(ini.get("global", "c"), Some(&Value::Float("1.5e3".into())));
        assert_eq!(ini.get("global", "d"), Some(&Value::Float("08".into())));
        assert_eq!(ini.get("global", "e"), Some(&Value::Str("1a".into())));
    }

    #[test]
    fn rejects_garbage() {
        assert!(Ini::parse("nonsense\n").is_err());
    }
}
