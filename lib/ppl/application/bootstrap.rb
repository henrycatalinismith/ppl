
class Ppl::Application::Bootstrap

  def command_suite
    suite = Ppl::Application::CommandSuite.new
    suite.add_command(Ppl::Command::CommandList.new)
    suite.add_command(Ppl::Command::ContactDelete.new)
    suite.add_command(Ppl::Command::ContactList.new)
    suite.add_command(Ppl::Command::ContactRename.new)
    suite.add_command(Ppl::Command::ContactShow.new)
    return suite
  end

  def input
    input = Ppl::Application::Input.new(ARGV.dup)
    return input
  end

  def output
    output = Ppl::Application::Output.new($stdout, $stderr)
    return output
  end

  def router
    router = Ppl::Application::Router.new(command_suite)
    router.default = "help"
    return router
  end

  def shell
    shell = Ppl::Application::Shell.new
    shell.router = router
    return shell
  end

end

