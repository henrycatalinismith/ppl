
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

  end

end

