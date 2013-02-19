
require "morphine"

class Ppl::Application::Bootstrap

  include Morphine

  register :commands do
    commands = [
      Ppl::Command::Add.new,
      Ppl::Command::Age.new,
      Ppl::Command::Bday.new,
      Ppl::Command::Email.new,
      Ppl::Command::Help.new,
      Ppl::Command::Init.new,
      Ppl::Command::Ls.new,
      Ppl::Command::Mutt.new,
      Ppl::Command::Mv.new,
      Ppl::Command::Name.new,
      Ppl::Command::Nick.new,
      Ppl::Command::Org.new,
      Ppl::Command::Phone.new,
      Ppl::Command::Post.new,
      Ppl::Command::Rm.new,
      Ppl::Command::Shell.new,
      Ppl::Command::Show.new,
      Ppl::Command::Url.new,
      Ppl::Command::Version.new,
    ]
    commands += git_commands
    commands.each do |command|
      command.storage = storage_adapter
    end
    commands
  end

  register :command_suite do
    command_suite = Ppl::Application::CommandSuite.new
    commands.each do |command|
      command_suite.add_command(command)
    end
    command_suite.find_command("help").command_suite = command_suite
    command_suite
  end

  register :configuration do
    Ppl::Application::Configuration.new
  end

  register :execute_command do
    command = Ppl::Command::Execute.new(nil, nil, nil)
    command.storage = storage_adapter
    command
  end

  register :git_commands do
    [
      Ppl::Command::Execute.new("pull", "git pull", "Execute 'git pull' in the address book directory"),
      Ppl::Command::Execute.new("push", "git push", "Execute 'git push' in the address book directory"),
      Ppl::Command::Execute.new("remote", "git remote", "Execute 'git remote' in the address book directory"),
    ]
  end

  register :input do
    Ppl::Application::Input.new(ARGV.dup)
  end

  register :output do
    Ppl::Application::Output.new($stdout, $stderr)
  end

  register :router do
    router = Ppl::Application::Router.new(command_suite)
    router.aliases = configuration.aliases
    router.default = "help"
    router.execute_command = execute_command
    router
  end

  register :shell do
    shell = Ppl::Application::Shell.new
    shell.router = router
    shell
  end

  register :storage_adapter do
    config = configuration
    directory = Dir.new(config.address_book_path)
    factory   = Ppl::Adapter::Storage::Factory.new(vcard_adapter)
    storage   = factory.load_adapter(directory)
    storage.vcard_adapter = vcard_adapter
    storage
  end

  register :vcard_adapter do
    Ppl::Adapter::Vcard::Vpim.new
  end

end

