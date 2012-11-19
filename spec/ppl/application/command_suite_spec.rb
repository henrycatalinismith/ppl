

describe Ppl::Application::CommandSuite, "#commands" do

  before(:each) do
    @command_suite = Ppl::Application::CommandSuite.new
  end

  it "is an array" do
    @command_suite.commands.should be_an(Array)
  end

end


describe Ppl::Application::CommandSuite, "#add_command" do

  before(:each) do
    @command_suite = Ppl::Application::CommandSuite.new
  end

  it "should accept a command" do
    @command_suite.add_command(Ppl::Command.new)
    @command_suite.commands.length.should be 1
  end

end


describe Ppl::Application::CommandSuite, "#find_command" do

  before(:each) do
    @command_suite = Ppl::Application::CommandSuite.new

    @foo_command      = Ppl::Command.new
    @foo_command.name = "foo"

    @bar_command      = Ppl::Command.new
    @bar_command.name = "bar"

    @command_suite.add_command(@foo_command)
    @command_suite.add_command(@bar_command)
  end

  it "should find a command matching the given name" do
    @command_suite.find_command("foo").should be @foo_command
  end

  it "should return nil if no commands match the given name" do
    @command_suite.find_command("baz").should be nil
  end

end

