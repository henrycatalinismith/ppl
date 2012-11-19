
class Ppl::Application::Bootstrap

  def command_suite
    suite = Ppl::Application::CommandSuite.new

    suite.add_command(Ppl::Command::Ls.new)

    return suite
  end

  def shell
    shell = Ppl::Application::Shell.new
    shell.command_suite = command_suite
    return shell
  end

end

