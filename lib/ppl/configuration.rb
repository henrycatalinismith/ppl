
require "inifile"
require "deep_merge"

class Ppl::Configuration

  @@config_path = "~/.pplconfig"

  def to_h

    config = {}
    config = config.deep_merge! self.default_config
    config = config.deep_merge! self.system_config
    config = config.deep_merge! self.user_config
    config = config.deep_merge! self.local_config

    config["address_book"]["path"] = File.expand_path config["address_book"]["path"]
    config
  end

  def [](key)
    to_h[key]
  end

  def default_config
    {
      "address_book" => {
        "path" => Dir.pwd,
      },
      "alias" => {},
      "color" => {
        "contact:list" => false,
      },
    }
  end

  def system_config
    {}
  end

  def user_config
    path = File.expand_path "~/.pplconfig"
    if File.exists? path
      IniFile::load(path).to_h
    end
  end

  def local_config
    config = {}
    path   = File.join(Dir.pwd, ".ppl")

    if File.exists? path
      cpath = File.join(path, "config")
      if File.exists? cpath
        config = IniFile::load(cpath).to_h
      end

      config["address_book"]["path"] = Dir.pwd
    end

    return config
  end

end

