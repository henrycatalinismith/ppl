
describe Ppl::Command::CommandList do

  before(:each) do
    @command = Ppl::Command::CommandList.new
  end

  describe "#name" do
    it "should be 'help'" do
      @command.name.should eq "help"
    end
  end

end

