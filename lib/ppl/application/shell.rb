
class Ppl::Application::Shell

  attr_writer :command_suite

  def run(arguments)

    command = select_command(arguments)
    if command.nil?
      return false
    end

    execute_command(command, arguments)

  end


  private

  def select_command(arguments)
    @command_suite.find_command(arguments.first)
  end

  def execute_command(command, arguments)
    command.execute
  end

end

