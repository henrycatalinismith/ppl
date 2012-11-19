
describe Ppl::Application::CommandSuite do

  before(:each) do
    @command_suite = Ppl::Application::CommandSuite.new

    @foo_command      = Ppl::Command.new
    @foo_command.name = "foo"

    @bar_command      = Ppl::Command.new
    @bar_command.name = "bar"

    @command_suite.add_command(@foo_command)
    @command_suite.add_command(@bar_command)
  end

  describe "#add_command" do
    it "should accept a command" do
      @command_suite.add_command(Ppl::Command.new)
      @command_suite.count.should be 3
    end
  end

  describe "#find_command" do
    it "should find a command matching the given name" do
      @command_suite.find_command("foo").should be @foo_command
    end
    it "should return nil if no commands match the given name" do
      @command_suite.find_command("baz").should be nil
    end
  end

  describe "#each" do
    it "should yield commands" do
      @command_suite
        .should_receive(:each)
        .and_yield(@foo_command)
        .and_yield(@bar_command)
      @command_suite.each do |c| end
    end
  end

end

