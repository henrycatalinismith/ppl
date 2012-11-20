
describe Ppl::Application::Shell do

  before(:each) do
    @shell  = Ppl::Application::Shell.new
    @input  = Ppl::Application::Input.new
    @output = Ppl::Application::Output.new(nil, nil)

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

      @shell.run(@input, @output)
    end

  end

end

