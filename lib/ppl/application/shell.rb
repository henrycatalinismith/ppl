
class Ppl::Application::Shell

  attr_writer :command_suite

  def run(input)

    command = select_command(input)
    if command.nil?
      return false
    end

    execute_command(command, input)

  end


  private

  def select_command(input)
    @command_suite.find_command(input.arguments.first)
  end

  def execute_command(command, input)
    command.execute
  end

end

