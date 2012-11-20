
describe Ppl::Application::Shell do

  before(:each) do
    @shell = Ppl::Application::Shell.new
    @input = Ppl::Application::Input.new

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
      @shell.run(@input).should eq false
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
      @shell.run(@input).should eq true
    end

  end

end

