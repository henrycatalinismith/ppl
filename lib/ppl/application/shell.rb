
class Ppl::Application::Shell

  attr_writer :command_suite

  def run(argv)

    command = @command_suite.find_command(argv.first)

    if command.nil?
      return false
    end

  end

end

