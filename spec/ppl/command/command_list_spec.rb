
describe Ppl::Command::CommandList do

  before(:each) do
    @command = Ppl::Command::CommandList.new
    @output  = double(Ppl::Application::Output)

    @command.command_suite = Ppl::Application::CommandSuite.new
  end

  describe "#command_suite=" do
    it "should accept a value" do
      suite = Object.new
      @command.command_suite = suite
      @command.command_suite.should be suite
    end
  end

  describe "#name" do
    it "should be 'help'" do
      @command.name.should eq "help"
    end
  end

  describe "#execute" do

    it "should not list itself" do
      @command.command_suite.add_command(@command)

      @output.should_receive(:line).with("usage: ppl <command>")
      @output.should_receive(:line).with(nil)
      @output.should_receive(:line).with(nil)

      @command.execute(nil, @output)
    end

    it "should list available commands" do
      command = double(Ppl::Application::Command)
      command.should_receive(:name).twice.and_return("one")
      command.should_receive(:description).and_return("The first command")
      @command.command_suite.add_command(command)

      @output.should_receive(:line).with("usage: ppl <command>")
      @output.should_receive(:line).with(nil)
      @output.should_receive(:line).with("   one   The first command")
      @output.should_receive(:line).with(nil)

      @command.execute(nil, @output)
    end

    it "should arrange output into columns" do
      command_foo = Ppl::Application::Command.new
      command_foo.name = "shortname"
      command_foo.description = "This is a command with a short name"

      command_bar = Ppl::Application::Command.new
      command_bar.name = "veryverylongname"
      command_bar.description = "This is a command with a longer name"

      @command.command_suite.add_command(command_foo)
      @command.command_suite.add_command(command_bar)

      @output.should_receive(:line).with("usage: ppl <command>")
      @output.should_receive(:line).with(nil)
      [
        "   shortname          This is a command with a short name",
        "   veryverylongname   This is a command with a longer name",
      ].each do |line|
        @output.should_receive(:line).with(line)
      end
      @output.should_receive(:line).with(nil)

      @command.execute(nil, @output)
    end

  end

end

