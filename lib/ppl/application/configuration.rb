
class Ppl::Application::Configuration

  USER_CONFIG = "~/.pplconfig"
  REPO_CONFIG = "./.ppl/config"

  def address_book_path
    default_config = default_configuration
    user_config    = user_configuration

    path = default_config["address book"]["path"]
    if !user_config["address book"].nil? && !user_config["address book"]["path"].nil?
      path = File.expand_path(user_config["address book"]["path"])
    end

    return path
  end

  private

  def default_configuration
    {
      "address book" => {
        "path" => Dir.pwd
      },
    }
  end

  def user_configuration
    filename = File.expand_path(USER_CONFIG)
    config   = File.read(filename)
  end

  def repository_configuration
    {}
  end

end

