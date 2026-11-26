//! Small helpers that mirror Ruby string behaviour, so output stays identical
//! to the original Ruby implementation.

fn is_ruby_space(c: char) -> bool {
    matches!(c, ' ' | '\t' | '\n' | '\x0b' | '\x0c' | '\r' | '\0')
}

/// Ruby's `String#strip`.
pub fn strip(s: &str) -> &str {
    s.trim_matches(is_ruby_space)
}

/// Ruby's `String#rstrip`.
pub fn rstrip(s: &str) -> &str {
    s.trim_end_matches(is_ruby_space)
}

/// `sprintf("%-Ns", s)`: left-justify by character count.
pub fn ljust(s: &str, width: usize) -> String {
    let len = s.chars().count();
    let mut out = s.to_string();
    out.extend(std::iter::repeat_n(' ', width.saturating_sub(len)));
    out
}

pub fn rjust(s: &str, width: usize) -> String {
    let len = s.chars().count();
    let mut out: String = std::iter::repeat_n(' ', width.saturating_sub(len)).collect();
    out.push_str(s);
    out
}

/// Ruby's `String#split(";")`, which drops trailing empty fields.
pub fn split_drop_trailing<'a>(s: &'a str, sep: &str) -> Vec<&'a str> {
    let mut parts: Vec<&str> = s.split(sep).collect();
    while parts.last() == Some(&"") {
        parts.pop();
    }
    parts
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn strips_like_ruby() {
        assert_eq!(strip("  a b \n"), "a b");
        assert_eq!(rstrip(" a \t"), " a");
    }

    #[test]
    fn split_like_ruby() {
        assert_eq!(split_drop_trailing("a;;b;;", ";"), vec!["a", "", "b"]);
        assert_eq!(split_drop_trailing("", ";"), Vec::<&str>::new());
    }
}
