
describe Ppl::Application::Shell do

  before(:each) do
    @shell  = Ppl::Application::Shell.new
    @input  = Ppl::Application::Input.new
    @output = double(Ppl::Application::Output)

    @router  = double(Ppl::Application::Router)
    @command = double(Ppl::Application::Command)

    @shell.router = @router
  end

  describe "#run" do

    it "should return false if the given command isn't found" do
      @input.arguments = ["foo"]
      @router
        .should_receive(:route)
        .with("foo")
        .and_return(nil)
      @shell.run(@input, @output).should eq false
    end

    it "should execute the given command" do
      @input.arguments = ["foo"]
      @router
        .should_receive(:route)
        .with("foo")
        .and_return(@command)

      @command
        .should_receive(:execute)
        .and_return(true)

      @shell.run(@input, @output).should eq true
    end

    it "should return false if the command throws an exception" do
      @command
        .should_receive(:execute)
        .and_raise(StandardError)

      @router
        .should_receive(:route)
        .and_return(@command)

      @output.should_receive(:error)

      @shell.run(@input, @output)
    end

    it "should send exception messages to stderr" do
      @command.should_receive(:execute) { raise "Pool's Closed" }
      @router.should_receive(:route).and_return(@command)

      @output.should_receive(:error).with("Pool's Closed")

      @shell.run(@input, @output)
    end

  end

end

