
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

      @command.should_receive(:options)
      @command
        .should_receive(:execute)
        .and_return(true)

      @shell.run(@input, @output).should eq true
    end

    it "should not pass the command name in the input to the command itself" do
      @input.arguments = ["mv", "foo", "bar"]
      @router
        .should_receive(:route)
        .with("mv")
        .and_return(@command)

      @command.should_receive(:options)
      @command.should_receive(:execute) do |input, output|
        input.arguments.should eq ["foo", "bar"]
      end
      @shell.run(@input, @output)
    end

    it "should return false if the command throws an exception" do
      @command.should_receive(:options)
      @command
        .should_receive(:execute)
        .and_raise(StandardError)

      @router
        .should_receive(:route)
        .and_return(@command)

      @output.should_receive(:error)

      @shell.run(@input, @output)
    end

    it "should not do any option parsing for Ppl::Command::Execute instances" do
      execute = Ppl::Command::Execute.new("ls", "ls", "List directory contents")
      execute.stub(:execute).and_return(true)
      @shell.should_receive(:select_command).and_return(execute)
      execute.should_not_receive(:options)
      @shell.run(@input, @output)
    end

    it "should send exception messages to stderr" do
      @command.should_receive(:options)
      @command.should_receive(:execute) { raise "Pool's Closed" }
      @router.should_receive(:route).and_return(@command)
      @output.should_receive(:error).with("ppl: Pool's Closed")
      @shell.run(@input, @output)
    end

    it "should handle ContactNotFound errors nicely" do
      @command.stub(:options)
      @command.should_receive(:execute) { raise Ppl::Error::ContactNotFound, "example" }
      @router.should_receive(:route).and_return(@command)
      @output.should_receive(:error).with("ppl: Contact 'example' not found")
      @shell.run(@input, @output)
    end

  end

end

