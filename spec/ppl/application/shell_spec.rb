
describe Ppl::Application::Shell do

  before(:each) do
    @shell = Ppl::Application::Shell.new

    @command_suite = double(Ppl::Application::CommandSuite)
    @command       = double(Ppl::Application::Command)

    @shell.command_suite = @command_suite
  end

  describe "#run" do

    it "should return false if the given command isn't found" do
      @command_suite
        .should_receive(:find_command)
        .with("foo")
        .and_return(nil)
      @shell.run(["foo"]).should eq false
    end

    it "should execute the given command" do
      @command_suite
        .should_receive(:find_command)
        .with("foo")
        .and_return(@command)
      @command
        .should_receive(:execute)
        .and_return(true)
      @shell.run(["foo"]).should eq true
    end

  end

end

