//! Parses the birthday formats accepted by Ruby's `Date.parse` that people
//! are likely to type.

use std::sync::LazyLock;

use chrono::{Datelike, NaiveDate};
use regex::Regex;

static YMD: LazyLock<Regex> = LazyLock::new(|| {
    Regex::new(r"^([0-9]{4})[-/.]([0-9]{1,2})[-/.]([0-9]{1,2})(?:[t ].*)?$").unwrap()
});
static COMPACT: LazyLock<Regex> =
    LazyLock::new(|| Regex::new(r"^([0-9]{4})([0-9]{2})([0-9]{2})$").unwrap());
static DMY: LazyLock<Regex> =
    LazyLock::new(|| Regex::new(r"^([0-9]{1,2})[-/.]([0-9]{1,2})[-/.]([0-9]{4})$").unwrap());
static SHORT_YMD: LazyLock<Regex> =
    LazyLock::new(|| Regex::new(r"^([0-9]{2})-([0-9]{2})-([0-9]{2})$").unwrap());

const MONTHS: [&str; 12] = [
    "january",
    "february",
    "march",
    "april",
    "may",
    "june",
    "july",
    "august",
    "september",
    "october",
    "november",
    "december",
];

const WEEKDAYS: [&str; 7] = [
    "monday",
    "tuesday",
    "wednesday",
    "thursday",
    "friday",
    "saturday",
    "sunday",
];

fn two_digit_year(y: i32) -> i32 {
    if y >= 69 {
        1900 + y
    } else {
        2000 + y
    }
}

fn abbreviates(token: &str, names: &[&str]) -> Option<usize> {
    if token.len() < 3 {
        return None;
    }
    names.iter().position(|n| n.starts_with(token))
}

pub fn parse(input: &str, today: NaiveDate) -> Option<NaiveDate> {
    let s = input.trim().to_lowercase();
    let num = |c: &regex::Captures, i: usize| c[i].parse::<u32>().ok();

    if let Some(c) = YMD.captures(&s).or_else(|| COMPACT.captures(&s)) {
        return NaiveDate::from_ymd_opt(num(&c, 1)? as i32, num(&c, 2)?, num(&c, 3)?);
    }
    if let Some(c) = DMY.captures(&s) {
        return NaiveDate::from_ymd_opt(num(&c, 3)? as i32, num(&c, 2)?, num(&c, 1)?);
    }
    if let Some(c) = SHORT_YMD.captures(&s) {
        let y = two_digit_year(num(&c, 1)? as i32);
        return NaiveDate::from_ymd_opt(y, num(&c, 2)?, num(&c, 3)?);
    }

    let mut month = None;
    let mut day = None;
    let mut year = None;
    for token in s
        .split(|c: char| !c.is_alphanumeric())
        .filter(|t| !t.is_empty())
    {
        if let Some(m) = abbreviates(token, &MONTHS) {
            if month.is_some() {
                return None;
            }
            month = Some(m as u32 + 1);
            continue;
        }
        if abbreviates(token, &WEEKDAYS).is_some() {
            continue;
        }
        let digits = ["st", "nd", "rd", "th"]
            .iter()
            .find_map(|suffix| token.strip_suffix(suffix))
            .unwrap_or(token);
        if digits.is_empty() || !digits.chars().all(|c| c.is_ascii_digit()) {
            return None;
        }
        let n: i32 = digits.parse().ok()?;
        if digits.len() >= 3 {
            if year.is_some() {
                return None;
            }
            year = Some(n);
        } else if day.is_none() {
            day = Some(n as u32);
        } else if year.is_none() {
            year = Some(two_digit_year(n));
        } else {
            return None;
        }
    }

    let month = month?;
    let day = match (day, year) {
        (Some(d), _) => d,
        (None, Some(_)) => 1,
        (None, None) => return None,
    };
    NaiveDate::from_ymd_opt(year.unwrap_or(today.year()), month, day)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parses_like_ruby() {
        let today = NaiveDate::from_ymd_opt(2026, 11, 26).unwrap();
        let cases = [
            ("1980-02-03", Some("1980-02-03")),
            ("19800203", Some("1980-02-03")),
            ("1980/2/3", Some("1980-02-03")),
            ("13/02/1980", Some("1980-02-13")),
            ("3 Feb 1980", Some("1980-02-03")),
            ("Feb 3 1980", Some("1980-02-03")),
            ("February 3, 1980", Some("1980-02-03")),
            ("3rd February 1980", Some("1980-02-03")),
            ("2 March", Some("2026-03-02")),
            ("1980.02.03", Some("1980-02-03")),
            ("03.02.1980", Some("1980-02-03")),
            ("Sat, 3 Feb 1980", Some("1980-02-03")),
            ("3-2-1980", Some("1980-02-03")),
            ("80-02-03", Some("1980-02-03")),
            ("Mar 2nd, 1980", Some("1980-03-02")),
            ("1980 Feb 3", Some("1980-02-03")),
            ("3 feb 80", Some("1980-02-03")),
            ("1980-02-03T10:00", Some("1980-02-03")),
            ("Feb 1980", Some("1980-02-01")),
            ("1980-02-30", None),
            ("02/13/1980", None),
            ("foo", None),
            ("1980", None),
            ("3", None),
        ];
        for (input, expected) in cases {
            let got = parse(input, today).map(|d| d.to_string());
            assert_eq!(got.as_deref(), expected, "{input}");
        }
    }
}
