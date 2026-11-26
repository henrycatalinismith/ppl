//! Emulates the behaviour of Ruby's OptionParser that ppl's users can see:
//! the usage summaries, permuted arguments, abbreviated long options, short
//! options completing to long ones, and the error messages.

use std::collections::HashMap;

use regex::Regex;

use crate::error::Error;

pub struct Switch {
    pub short: Option<char>,
    /// Whether the short option is listed in the usage summary. A later
    /// switch can take over the short option of an earlier one.
    pub show_short: bool,
    pub long: &'static str,
    pub arg: Option<&'static str>,
    pub description: &'static str,
    pub key: &'static str,
    /// The value stored for switches without an argument.
    pub flag: bool,
}

pub const fn flag(
    short: Option<char>,
    long: &'static str,
    key: &'static str,
    flag: bool,
    description: &'static str,
) -> Switch {
    Switch {
        short,
        show_short: true,
        long,
        arg: None,
        description,
        key,
        flag,
    }
}

pub const fn arg(
    short: Option<char>,
    long: &'static str,
    arg: &'static str,
    key: &'static str,
    description: &'static str,
) -> Switch {
    Switch {
        short,
        show_short: true,
        long,
        arg: Some(arg),
        description,
        key,
        flag: true,
    }
}

#[derive(Clone, Debug, PartialEq)]
pub enum OptValue {
    Flag(bool),
    Str(String),
}

#[derive(Debug, Default)]
pub struct Options(HashMap<&'static str, OptValue>);

impl Options {
    pub fn is_empty(&self) -> bool {
        self.0.is_empty()
    }

    pub fn flag(&self, key: &str) -> Option<bool> {
        match self.0.get(key) {
            Some(OptValue::Flag(b)) => Some(*b),
            _ => None,
        }
    }

    pub fn is_set(&self, key: &str) -> bool {
        self.flag(key) == Some(true)
    }

    pub fn str(&self, key: &str) -> Option<&str> {
        match self.0.get(key) {
            Some(OptValue::Str(s)) => Some(s),
            _ => None,
        }
    }
}

pub struct Parser<'a> {
    pub banner: &'a str,
    pub switches: &'a [Switch],
}

pub enum Outcome {
    Parsed(Vec<String>, Options),
    /// `--help` was given: print this and exit successfully.
    Help(String),
}

const SUMMARY_WIDTH: usize = 32;
const SUMMARY_INDENT: &str = "    ";

enum Found<'a> {
    Switch(&'a Switch),
    Help,
    Version,
}

impl<'a> Parser<'a> {
    pub fn help(&self) -> String {
        let mut out = format!("{}\n", self.banner);
        for s in self.switches {
            let mut left = match s.short.filter(|_| s.show_short) {
                Some(c) => format!("-{c}, "),
                None => "    ".to_string(),
            };
            left.push_str("--");
            left.push_str(s.long);
            if let Some(a) = s.arg {
                left.push(' ');
                left.push_str(a);
            }
            let line = if s.description.is_empty() {
                format!("{SUMMARY_INDENT}{left}")
            } else if left.len() <= SUMMARY_WIDTH {
                format!("{SUMMARY_INDENT}{left:<SUMMARY_WIDTH$} {}", s.description)
            } else {
                format!(
                    "{SUMMARY_INDENT}{left}\n{SUMMARY_INDENT}{:SUMMARY_WIDTH$} {}",
                    "", s.description
                )
            };
            out.push_str(&line);
            out.push('\n');
        }
        out
    }

    /// The candidates OptionParser's `DidYouMean` integration suggests.
    fn suggestions(&self, input: &str) -> String {
        let dictionary: Vec<&str> = self
            .switches
            .iter()
            .map(|s| s.long)
            .chain(OFFICIOUS)
            .collect();
        let corrections = did_you_mean(input, &dictionary);
        let ordered: Vec<&str> = dictionary
            .iter()
            .copied()
            .filter(|d| corrections.contains(d))
            .collect();
        if ordered.is_empty() {
            String::new()
        } else {
            format!("\nDid you mean?  {}", ordered.join("\n               "))
        }
    }

    fn complete_long(&self, arg: &str, opt: &str, icase: bool) -> Result<Found<'a>, Error> {
        if let Some(s) = self.switches.iter().find(|s| s.long == opt) {
            return Ok(Found::Switch(s));
        }
        match opt {
            "help" => return Ok(Found::Help),
            "version" => return Ok(Found::Version),
            _ => {}
        }

        let pattern = completion_regex(opt, icase);
        let switches: Vec<(&str, Found<'a>)> = self
            .switches
            .iter()
            .map(|s| (s.long, Found::Switch(s)))
            .collect();
        let officious = vec![("help", Found::Help), ("version", Found::Version)];
        for list in [switches, officious] {
            let mut candidates: Vec<(&str, Found<'a>)> = list
                .into_iter()
                .filter(|(k, _)| pattern.is_match(k))
                .collect();
            candidates.sort_by_key(|(k, _)| k.len());
            let mut candidates = candidates.into_iter();
            let Some((mut canon_name, mut canon)) = candidates.next() else {
                continue;
            };
            for (name, found) in candidates {
                if canon_name.starts_with(name) {
                    canon_name = name;
                    canon = found;
                } else if !name.starts_with(canon_name) {
                    return Err(Error::Other(format!(
                        "ambiguous option: {arg}{}",
                        self.suggestions(opt)
                    )));
                }
            }
            return Ok(canon);
        }
        Err(Error::Usage(format!(
            "invalid option: {arg}{}",
            self.suggestions(opt)
        )))
    }

    pub fn parse(&self, args: Vec<String>) -> Result<Outcome, Error> {
        let mut options = Options::default();
        let mut rest: Vec<String> = Vec::new();
        let mut args = args.into_iter();

        while let Some(a) = args.next() {
            if a == "--" {
                rest.extend(args.by_ref());
                break;
            }
            if let Some(long) = a.strip_prefix("--") {
                let (name, inline) = match long.split_once('=') {
                    Some((n, v)) => (n, Some(v.to_string())),
                    None => (long, None),
                };
                let name = name.replace('_', "-");
                let s = match self.complete_long(&a, &name, true)? {
                    Found::Help => return Ok(Outcome::Help(self.help())),
                    Found::Version => return Err(Error::Other("version unknown".into())),
                    Found::Switch(s) => s,
                };
                match s.arg {
                    None if inline.is_some() => {
                        return Err(Error::Other(format!("needless argument: {a}")));
                    }
                    None => {
                        options.0.insert(s.key, OptValue::Flag(s.flag));
                    }
                    Some(_) => {
                        let Some(value) = inline.or_else(|| args.next()) else {
                            return Err(Error::Usage(format!("missing argument: {a}")));
                        };
                        options.0.insert(s.key, OptValue::Str(value));
                    }
                }
            } else if a.len() > 1 && a.starts_with('-') {
                let mut chars: Vec<char> = a[1..].chars().collect();
                while !chars.is_empty() {
                    let current: String =
                        std::iter::once('-').chain(chars.iter().copied()).collect();
                    let c = chars.remove(0);
                    let exact = self.switches.iter().rev().find(|s| s.short == Some(c));
                    let found = match exact {
                        Some(s) => Found::Switch(s),
                        None => self.complete_long(&current, &c.to_string(), false)?,
                    };
                    let s = match found {
                        Found::Help => return Ok(Outcome::Help(self.help())),
                        Found::Version => return Err(Error::Other("version unknown".into())),
                        Found::Switch(s) => s,
                    };
                    if s.arg.is_some() {
                        let value = if chars.is_empty() {
                            match args.next() {
                                Some(v) => v,
                                None => {
                                    return Err(Error::Usage(format!(
                                        "missing argument: {current}"
                                    )))
                                }
                            }
                        } else {
                            chars.drain(..).collect()
                        };
                        options.0.insert(s.key, OptValue::Str(value));
                    } else {
                        options.0.insert(s.key, OptValue::Flag(s.flag));
                    }
                }
            } else {
                rest.push(a);
            }
        }

        Ok(Outcome::Parsed(rest, options))
    }
}

const OFFICIOUS: [&str; 4] = ["help", "*-completion-bash", "*-completion-zsh", "version"];

/// OptionParser's `Completion.regexp`: every word of the key may be
/// abbreviated, so `no-pref` matches `not-preferred`.
fn completion_regex(key: &str, icase: bool) -> Regex {
    let quoted = regex::escape(key);
    let mut pattern = String::from(if icase { "(?i)^" } else { "^" });
    let mut in_word = false;
    for c in quoted.chars() {
        let word = c.is_ascii_alphanumeric() || c == '_';
        if in_word && !word {
            pattern.push_str("[0-9A-Za-z_]*");
        }
        pattern.push(c);
        in_word = word;
    }
    if in_word {
        pattern.push_str("[0-9A-Za-z_]*");
    }
    Regex::new(&pattern).unwrap()
}

#[allow(clippy::needless_range_loop)]
fn jaro(a: &str, b: &str) -> f64 {
    let (mut s1, mut s2): (Vec<char>, Vec<char>) = (a.chars().collect(), b.chars().collect());
    if s1.len() > s2.len() {
        std::mem::swap(&mut s1, &mut s2);
    }
    let (len1, len2) = (s1.len(), s2.len());
    let range = if len2 > 3 { len2 / 2 - 1 } else { 0 };
    let mut flags1 = vec![false; len1];
    let mut flags2 = vec![false; len2 + range + 1];
    let mut m = 0.0;
    for i in 0..len1 {
        let start = i.saturating_sub(range);
        for j in start..=i + range {
            if !flags2[j] && s2.get(j) == Some(&s1[i]) {
                flags2[j] = true;
                flags1[i] = true;
                m += 1.0;
                break;
            }
        }
    }
    let mut t = 0.0;
    let mut k = 0;
    for i in 0..len1 {
        if flags1[i] {
            let mut index = k;
            let mut j = k;
            while j < len2 {
                index = j;
                if flags2[j] {
                    k = j + 1;
                    break;
                }
                j += 1;
            }
            if s2.get(index) != Some(&s1[i]) {
                t += 1.0;
            }
        }
    }
    let t = (t / 2.0_f64).floor();
    if m == 0.0 {
        0.0
    } else {
        (m / len1 as f64 + m / len2 as f64 + (m - t) / m) / 3.0
    }
}

fn jaro_winkler(a: &str, b: &str) -> f64 {
    let d = jaro(a, b);
    if d <= 0.7 {
        return d;
    }
    let b: Vec<char> = b.chars().collect();
    let mut prefix = 0;
    for c in a.chars() {
        if b.get(prefix) == Some(&c) && prefix < 4 {
            prefix += 1;
        } else {
            break;
        }
    }
    d + prefix as f64 * 0.1 * (1.0 - d)
}

fn levenshtein(a: &str, b: &str) -> usize {
    let a: Vec<char> = a.chars().collect();
    let b: Vec<char> = b.chars().collect();
    if a.is_empty() {
        return b.len();
    }
    if b.is_empty() {
        return a.len();
    }
    let mut row: Vec<usize> = (0..=b.len()).collect();
    for (i, ca) in a.iter().enumerate() {
        let mut prev = row[0];
        row[0] = i + 1;
        for (j, cb) in b.iter().enumerate() {
            let cost = if ca == cb { 0 } else { 1 };
            let next = (row[j + 1] + 1).min(row[j] + 1).min(prev + cost);
            prev = row[j + 1];
            row[j + 1] = next;
        }
    }
    row[b.len()]
}

/// A port of `DidYouMean::SpellChecker#correct`.
fn did_you_mean<'d>(input: &str, dictionary: &[&'d str]) -> Vec<&'d str> {
    let normalize = |s: &str| s.to_lowercase().replace('@', "");
    let input_n = normalize(input);
    let input_len = input_n.chars().count();
    let threshold = if input_len > 3 { 0.834 } else { 0.77 };
    let mut words: Vec<&str> = dictionary
        .iter()
        .copied()
        .filter(|w| jaro_winkler(&normalize(w), &input_n) >= threshold)
        .filter(|w| *w != input)
        .collect();
    words.sort_by(|a, b| {
        jaro_winkler(b, &input_n)
            .partial_cmp(&jaro_winkler(a, &input_n))
            .unwrap()
    });
    let max_distance = (input_len as f64 * 0.25).ceil() as usize;
    let corrections: Vec<&str> = words
        .iter()
        .copied()
        .filter(|w| levenshtein(&normalize(w), &input_n) <= max_distance)
        .collect();
    if !corrections.is_empty() {
        return corrections;
    }
    words
        .into_iter()
        .filter(|w| {
            let w = normalize(w);
            levenshtein(&w, &input_n) < input_len.min(w.chars().count())
        })
        .take(1)
        .collect()
}

#[cfg(test)]
mod tests {
    use super::*;

    const SWITCHES: &[Switch] = &[
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
    ];

    fn parser() -> Parser<'static> {
        Parser {
            banner: "usage: ppl email <contact> [<email-address>]",
            switches: SWITCHES,
        }
    }

    fn parse(args: &[&str]) -> Result<Outcome, Error> {
        parser().parse(args.iter().map(|s| s.to_string()).collect())
    }

    #[test]
    fn summary() {
        assert_eq!(
            parser().help(),
            "usage: ppl email <contact> [<email-address>]\n\
             \x20   -d, --delete                     delete email address\n\
             \x20   -p, --preferred                  mark address as preferred\n\
             \x20   -P, --not-preferred              mark address as not preferred\n\
             \x20       --format <format>            specify a custom output format\n"
        );
    }

    #[test]
    fn permutes_and_abbreviates() {
        let Ok(Outcome::Parsed(rest, opts)) =
            parse(&["bob", "-dP", "x@y", "--form", "%a", "--", "-z"])
        else {
            panic!()
        };
        assert_eq!(rest, vec!["bob", "x@y", "-z"]);
        assert!(opts.is_set("delete"));
        assert_eq!(opts.flag("preferred"), Some(false));
        assert_eq!(opts.str("format"), Some("%a"));
    }

    #[test]
    fn short_options_complete_to_long_ones() {
        let Ok(Outcome::Parsed(_, opts)) = parse(&["-f", "%a"]) else {
            panic!()
        };
        assert_eq!(opts.str("format"), Some("%a"));
        assert!(matches!(parse(&["-h"]), Ok(Outcome::Help(_))));
    }

    #[test]
    fn errors() {
        let Err(Error::Usage(m)) = parse(&["--bogus"]) else {
            panic!()
        };
        assert_eq!(m, "invalid option: --bogus");
        assert_eq!(
            parse(&["--delete=x"]).err(),
            Some(Error::Other("needless argument: --delete=x".into()))
        );
        assert_eq!(
            parse(&["--version"]).err(),
            Some(Error::Other("version unknown".into()))
        );
    }
}
