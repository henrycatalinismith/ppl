
class Ppl::Command::CommandList < Ppl::Application::Command

  attr_accessor :command_suite

  def initialize
    @name        = "help"
    @description = "Show a list of commands"
  end

  def execute(input, output)
    @command_suite.sort_by_name
    @command_suite.each do |command|
      name        = command.name
      description = command.description
      output.line("#{name}: #{description}")
    end
    return true
  end

end

