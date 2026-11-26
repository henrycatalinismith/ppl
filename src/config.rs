use std::collections::HashMap;
use std::env;
use std::path::{Path, PathBuf};

use crate::ini::{Ini, Value};

#[derive(Debug, Default)]
pub struct Configuration {
    user: Ini,
}

pub fn home() -> PathBuf {
    env::var_os("HOME").map(PathBuf::from).unwrap_or_default()
}

/// Ruby's `File.expand_path`: expands `~` and makes the path absolute.
pub fn expand_path(path: &str) -> PathBuf {
    let expanded = if path == "~" {
        home()
    } else if let Some(rest) = path.strip_prefix("~/") {
        home().join(rest)
    } else {
        PathBuf::from(path)
    };
    let absolute = if expanded.is_absolute() {
        expanded
    } else {
        env::current_dir().unwrap_or_default().join(expanded)
    };
    normalize(&absolute)
}

fn normalize(path: &Path) -> PathBuf {
    let mut out = PathBuf::new();
    for c in path.components() {
        match c {
            std::path::Component::CurDir => {}
            std::path::Component::ParentDir => {
                out.pop();
            }
            c => out.push(c),
        }
    }
    out
}

impl Configuration {
    pub fn load() -> Result<Configuration, String> {
        let user_config = expand_path("~/.pplconfig");
        let xdg_base = env::var("XDG_CONFIG_HOME").unwrap_or_else(|_| "~/.config".into());
        let xdg_config = expand_path(&xdg_base).join("ppl").join("config");
        let path = [user_config, xdg_config].into_iter().find(|p| p.exists());
        let user = match path {
            Some(p) => {
                let content = std::fs::read(&p).map_err(|e| e.to_string())?;
                Ini::parse(&String::from_utf8_lossy(&content))?
            }
            None => Ini::default(),
        };
        Ok(Configuration { user })
    }

    #[cfg(test)]
    pub fn from_ini(user: Ini) -> Configuration {
        Configuration { user }
    }

    pub fn address_book_path(&self) -> Result<PathBuf, String> {
        match self.user.get("address book", "path") {
            Some(Value::Str(s)) => Ok(expand_path(s)),
            None | Some(Value::Nil) => Ok(env::current_dir().unwrap_or_default()),
            Some(v) => Err(format!(
                "no implicit conversion of {} into String",
                v.ruby_class()
            )),
        }
    }

    pub fn aliases(&self) -> HashMap<String, Value> {
        self.user.sections.get("alias").cloned().unwrap_or_default()
    }

    fn color_enabled(&self, command: &str) -> bool {
        match self.user.get("color", command) {
            Some(Value::Bool(b)) => *b,
            Some(Value::Str(s)) => s == "true",
            _ => false,
        }
    }

    pub fn command_colors(&self, command: &str) -> HashMap<String, String> {
        if !self.color_enabled(command) {
            return HashMap::new();
        }
        self.user
            .sections
            .get(&format!("color \"{command}\""))
            .map(|s| {
                s.iter()
                    .filter_map(|(k, v)| Some((k.clone(), v.as_str()?.to_string())))
                    .collect()
            })
            .unwrap_or_default()
    }

    /// The `[pretty]` presets, or `None` when the section is missing.
    pub fn pretty(&self) -> Option<&HashMap<String, Value>> {
        self.user.sections.get("pretty")
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn colors_require_opt_in() {
        let ini = Ini::parse(
            "[color]\nls = true\n[color \"ls\"]\nid = red\n[color \"age\"]\nid = blue\n",
        )
        .unwrap();
        let config = Configuration::from_ini(ini);
        assert_eq!(
            config.command_colors("ls").get("id").map(|s| s.as_str()),
            Some("red")
        );
        assert!(config.command_colors("age").is_empty());
    }
}
