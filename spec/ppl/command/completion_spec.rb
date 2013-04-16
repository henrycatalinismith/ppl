
describe Ppl::Command::Completion do

  before(:each) do
    @command = Ppl::Command::Completion.new
    @input   = Ppl::Application::Input.new
    @output  = double(Ppl::Application::Output)
  end

  describe "#name" do
    it "should be 'completion'" do
      @command.name.should eq "completion"
    end
  end

  describe "#execute" do

    it "should raise an error if no shell is specified" do
      @input.arguments = []
      expect{@command.execute(@input, @output)}.to raise_error(Ppl::Error::IncorrectUsage)
    end

  end

end

