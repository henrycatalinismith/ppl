
Gem::Specification.new do |spec|

  spec.name        = "ppl"
  spec.version     = "1.5.1"
  spec.date        = "2012-12-20"

  spec.required_ruby_version = ">= 1.9.3"

  spec.summary     = "CLI Address Book"
  spec.description = "CLI Address Book"
  spec.license     = "GPL-2"

  spec.add_dependency("inifile", "2.0.2")
  spec.add_dependency("rugged", "0.17.0.b6")
  spec.add_dependency("vpim", "0.695")

  spec.authors     = ["Henry Smith"]
  spec.email       = "henry@henrysmith.org"

  spec.executables = "ppl"

  spec.files        = `git ls-files`.split("\n")
  spec.require_path = "lib"
  spec.homepage     = "http://ppladdressbook.org"

end

