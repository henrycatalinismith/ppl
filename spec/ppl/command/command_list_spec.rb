
describe Ppl::Command::CommandList do

  before(:each) do
    @command = Ppl::Command::CommandList.new
    @output  = double(Ppl::Application::Output)
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
    it "should list available commands" do
      command = double(Ppl::Application::Command)
      command.should_receive(:name).and_return("one")
      command.should_receive(:description).and_return("The first command")
      @command.command_suite = [command]

      @output.should_receive(:line).with("one: The first command")

      @command.execute(nil, @output)
    end
  end

end

