
class Ppl::Command::CommandList < Ppl::Application::Command

  attr_accessor :command_suite

  def initialize
    @name        = "help"
    @description = "Show a list of commands"
  end

  def execute(input, output)
    @command_suite.sort_by_name
    max_name_length = 0

    @command_suite.each do |command|
      name_length = command.name.length
      if name_length > max_name_length
        max_name_length = name_length
      end
    end

    @command_suite.each do |command|
      name        = command.name
      description = command.description

      line = sprintf("   %-#{max_name_length}s   %s", name, description)

      output.line(line)
    end
    return true
  end

end

