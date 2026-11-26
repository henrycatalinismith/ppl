use std::fmt;

#[derive(Debug, PartialEq)]
pub enum Error {
    /// Incorrect usage: the message is followed by the command's usage text.
    Usage(String),
    ContactNotFound(String),
    PostalAddressNotFound(String),
    CompletionNotFound(String),
    /// Any other failure, reported as `ppl: <message>`.
    Other(String),
}

impl fmt::Display for Error {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Error::Usage(m) => write!(f, "{m}"),
            Error::ContactNotFound(id) => write!(f, "ppl: Contact '{id}' not found"),
            Error::PostalAddressNotFound(id) => write!(f, "ppl: Postal address '{id}' not found"),
            Error::CompletionNotFound(s) => {
                write!(f, "ppl: No completion function available for '{s}'")
            }
            Error::Other(m) => write!(f, "ppl: {m}"),
        }
    }
}

impl From<std::io::Error> for Error {
    fn from(e: std::io::Error) -> Error {
        Error::Other(e.to_string())
    }
}

impl From<git2::Error> for Error {
    fn from(e: git2::Error) -> Error {
        Error::Other(e.message().to_string())
    }
}

pub type Result<T> = std::result::Result<T, Error>;
