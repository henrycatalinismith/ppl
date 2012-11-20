
class Ppl::Application::Bootstrap

  def command_suite
    suite = Ppl::Application::CommandSuite.new
    suite.add_command(Ppl::Command::ContactDelete.new)
    suite.add_command(Ppl::Command::ContactList.new)
    suite.add_command(Ppl::Command::ContactRename.new)
    suite.add_command(Ppl::Command::ContactShow.new)
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

