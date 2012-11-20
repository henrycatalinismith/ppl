
describe Ppl::Command::CommandHelp do

  before(:each) do
    @command = Ppl::Command::CommandHelp.new
  end

  describe "#name" do
    it "should be 'help'" do
      @command.name.should eq "help"
    end
  end

end

