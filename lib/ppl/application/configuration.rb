
class Ppl::Application::Configuration

  USER_CONFIG = "~/.pplconfig"
  REPO_CONFIG = "./.ppl/config"

  def default_configuration
    {
      "address book" => {
        "path" => Dir.pwd
      },
    }
  end

  def user_configuration
  end

  def repository_configuration
  end

end

