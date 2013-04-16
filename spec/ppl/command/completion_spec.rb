
describe Ppl::Command::Completion do

  before(:each) do
    @command = Ppl::Command::Completion.new
    @input   = Ppl::Application::Input.new
    @output  = double(Ppl::Application::Output)
    @directory = double(Dir)
    @command.completions_directory = @directory
  end

  describe "#name" do
    it "should be 'completion'" do
      @command.name.should eq "completion"
    end
  end

  describe "#execute" do

    before(:each) do
      @directory.stub(:exists?)
    end

    it "should raise an error if no shell is specified" do
      @input.arguments = []
      expect{@command.execute(@input, @output)}.to raise_error(Ppl::Error::IncorrectUsage)
    end

    it "should raise an error if the shell is not recognised" do
      @input.arguments = ["invalidshell"]
      @directory.should_receive(:exists?).with("invalidshell").and_return(false)
      expect{@command.execute(@input, @output)}.to raise_error(Ppl::Error::CompletionNotFound)
    end

  end

end

