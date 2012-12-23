
class Ppl::Command::Help < Ppl::Application::Command

  name        "help"
  description "Show a list of commands"

  attr_accessor :command_suite

  def execute(input, output)
    @command_suite.sort_by_name
    max_name_length = 0

    @command_suite.each do |command|
      name_length = command.name.length
      if name_length > max_name_length
        max_name_length = name_length
      end
    end

    output.line("usage: ppl <command>")
    output.line(nil)

    @command_suite.each do |command|
      name        = command.name
      description = command.description

      if self.name == name
        next
      end

      line = sprintf("   %-#{max_name_length}s   %s", name, description)

      output.line(line)
    end

    output.line(nil)
    return true
  end

end

