
Gem::Specification.new do |spec|

  spec.name        = "ppl"
  spec.version     = "0.0.5"
  spec.date        = "2012-11-13"

  spec.summary     = "CLI Address Book"
  spec.description = "Command-line driven address book"
  spec.license     = "GPL-2"

  spec.authors     = ["Henry Smith"]
  spec.email       = "henry@henrysmith.org"

  spec.executables = "ppl"

  spec.files        = `git ls-files`.split("\n")
  spec.require_path = "lib"
  spec.homepage     = "https://github.com/h2s/ppl"

end

