
class Ppl::Application::Bootstrap

  def command_suite
    suite = Ppl::Application::CommandSuite.new
    suite.add_command(Ppl::Command::ListContacts.new)
    return suite
  end

  def input(arguments=[])
    input = Ppl::Application::Input.new(arguments)
    return input
  end

  def shell
    shell = Ppl::Application::Shell.new
    shell.command_suite = command_suite
    return shell
  end

end

