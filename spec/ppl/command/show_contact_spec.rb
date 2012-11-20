
describe Ppl::Command::ShowContact do

  before(:each) do
    @command = Ppl::Command::ShowContact.new
  end

  describe "#name" do
    it "should be 'show'" do
      @command.name.should eq "show"
    end
  end

end

