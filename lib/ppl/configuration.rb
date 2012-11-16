
require "inifile"
require "deep_merge"

class Ppl::Configuration

  @@config_path = "~/.pplconfig"

  @@defaults = {
    "address_book" => {
      "path" => "~/ppl"
    },
    "alias" => {},
    "color" => {
      "contact:list" => false,
    },
  }

  def to_h

    config_path = File.expand_path @@config_path

    if File.exists? config_path
      custom = IniFile::load(config_path)
    end

    config = @@defaults.deep_merge! custom

    config["address_book"]["path"] = File.expand_path config["address_book"]["path"]

    config
  end

  def [](key)
    to_h[key]
  end

end

