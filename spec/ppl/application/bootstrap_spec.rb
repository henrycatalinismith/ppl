
describe Ppl::Application::Bootstrap do

  before(:each) do
    @bootstrap = Ppl::Application::Bootstrap.new
  end

  describe "#commands" do
    it "should return an array" do
      @bootstrap.commands.should be_an(Array)
    end
    it "should return commands" do
      @bootstrap.commands.each do |command|
        command.should be_a(Ppl::Application::Command)
      end
    end
    it "should inject a storage adapter into each command" do
      @bootstrap.commands.each do |command|
        command.storage.should be_a(Ppl::Adapter::Storage)
      end
    end
  end

  describe "#command_suite" do
    it "should return a Ppl::Application::CommandSuite" do
      @bootstrap.command_suite.should be_a(Ppl::Application::CommandSuite)
    end
    it "should contain the 'add' command" do
      @bootstrap.command_suite.find_command("add").should_not be nil
    end
    it "should contain the 'email' command" do
      @bootstrap.command_suite.find_command("email").should_not be nil
    end
    it "should contain the 'ls' command" do
      @bootstrap.command_suite.find_command("ls").should_not be nil
    end
    it "should contain the 'mv' command" do
      @bootstrap.command_suite.find_command("mv").should_not be nil
    end
    it "should contain the 'rm' command" do
      @bootstrap.command_suite.find_command("rm").should_not be nil
    end
    it "should contain the 'show' command" do
      @bootstrap.command_suite.find_command("show").should_not be nil
    end
    it "should contain the 'help' command" do
      @bootstrap.command_suite.find_command("help").should_not be nil
    end
  end

  describe "#input" do
    it "should return a Ppl::Application::Input" do
      @bootstrap.input.should be_a(Ppl::Application::Input)
    end
  end

  describe "#output" do
    it "should return a Ppl::Application::Output" do
      @bootstrap.output.should be_a(Ppl::Application::Output)
    end
  end

  describe "#router" do
    it "should return a Ppl::Application::Router" do
      @bootstrap.router.should be_a(Ppl::Application::Router)
    end
    it "should set the 'help' command as the default" do
      @bootstrap.router.default.should eq "help"
    end
  end

  describe "#shell" do
    it "should return a Ppl::Application::Shell" do
      @bootstrap.shell.should be_a(Ppl::Application::Shell)
    end
  end

  describe "#storage_adapter" do
    it "should return a Ppl::Adapter::Storage::Disk" do
      @bootstrap.storage_adapter.should be_a(Ppl::Adapter::Storage::Disk)
    end
  end

  describe "#vcard_adapter" do
    it "should return a Ppl::Adapter::Vcard::Vpim" do
      @bootstrap.vcard_adapter.should be_a(Ppl::Adapter::Vcard::Vpim)
    end
  end

end

