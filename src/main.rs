mod commands;
mod config;
mod dates;
mod entity;
mod error;
mod format;
mod ini;
mod opts;
mod rb;
mod storage;
mod vcard;

fn main() {
    let config = match config::Configuration::load() {
        Ok(c) => c,
        Err(e) => {
            eprintln!("ppl: {e}");
            std::process::exit(1);
        }
    };
    let args: Vec<String> = std::env::args().skip(1).collect();
    let app = commands::App::new(config);
    std::process::exit(app.run(args));
}
