
class Ppl::Command::CommandHelp < Ppl::Application::Command

  def initialize
    @name        = "help"
    @description = "Show a list of commands"
  end

end

