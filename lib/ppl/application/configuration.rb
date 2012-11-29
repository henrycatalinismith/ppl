
class Ppl::Application::Configuration

  USER_CONFIG = "~/.pplconfig"
  REPO_CONFIG = "./.ppl/config"

  def address_book_path
    default_config = default_configuration
    user_config    = user_configuration

    path = default_config["address book"]["path"]
    if !user_config["address book"].nil? && !user_config["address book"]["path"].nil?
      path = user_config["address book"]["path"]
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
    {}
  end

  def repository_configuration
    {}
  end

end

