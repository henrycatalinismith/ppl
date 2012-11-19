
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

