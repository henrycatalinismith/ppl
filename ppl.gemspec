
Gem::Specification.new do |spec|

  spec.name        = "ppl"
  spec.version     = "2.2.0"
  spec.date        = "2013-07-20"

  spec.required_ruby_version = ">= 1.9.3"

  spec.summary     = "The command line address book"
  spec.description = "ppl is a command-line address book using vCard & git for storage and synchronisation"
  spec.license     = "GPL-2"

  spec.add_dependency("colored", "1.2")
  spec.add_dependency("inifile", "2.0.2")
  spec.add_dependency("mail", "2.5.3")
  spec.add_dependency("morphine", "0.1.1")
  spec.add_dependency("rugged", "0.17.0.b6")
  spec.add_dependency("greencard", "0.0.5")

  spec.add_development_dependency("cucumber")
  spec.add_development_dependency("rspec")
  spec.add_development_dependency("rake")
  spec.add_development_dependency("fakefs")

  spec.authors     = ["Henry Smith"]
  spec.email       = "henry@henrysmith.org"

  spec.executables = "ppl"

  spec.files        = `git ls-files`.split("\n")
  spec.require_path = "lib"
  spec.homepage     = "http://ppladdressbook.org"

end

