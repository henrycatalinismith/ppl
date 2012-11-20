
class Ppl::Command::CommandList < Ppl::Application::Command

  def initialize
    @name        = "help"
    @description = "Show a list of commands"
  end

  def execute(input, output)
    output.line "help text goes here"
    return true
  end

end

