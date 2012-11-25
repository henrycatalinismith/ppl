
class Ppl::Application::Bootstrap

  def commands
    commands = [
      Ppl::Command::CommandList.new,
      Ppl::Command::ContactAdd.new,
      Ppl::Command::ContactDelete.new,
      Ppl::Command::ContactList.new,
      Ppl::Command::ContactRename.new,
      Ppl::Command::ContactShow.new,
    ]
    commands.each do |command|
      command.storage = storage_adapter
    end
    return commands
  end

  def command_suite
    suite = Ppl::Application::CommandSuite.new
    commands.each do |command|
      suite.add_command(command)
    end
    suite.find_command("help").command_suite = suite
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

  def storage_adapter
    storage = Ppl::Adapter::Storage::Disk.new(Dir.pwd)
    storage.vcard_adapter = vcard_adapter
    return storage
  end

  def vcard_adapter
    vcard = Ppl::Adapter::Vcard::Vpim.new
    return vcard
  end

end

