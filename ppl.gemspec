
Gem::Specification.new do |spec|

  spec.name        = "ppl"
  spec.version     = "1.0.1"
  spec.date        = "2012-12-20"

  spec.summary     = "CLI Address Book"
  spec.description = "CLI Address Book"
  spec.license     = "GPL-2"

  spec.authors     = ["Henry Smith"]
  spec.email       = "henry@henrysmith.org"

  spec.executables = "ppl"

  spec.files        = `git ls-files`.split("\n")
  spec.require_path = "lib"
  spec.homepage     = "https://github.com/h2s/ppl"

end

