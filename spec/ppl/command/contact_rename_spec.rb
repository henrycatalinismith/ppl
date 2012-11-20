
describe Ppl::Command::ContactRename do

  before(:each) do
    @command = Ppl::Command::ContactRename.new
  end

  describe "#name" do
    it "should be 'mv'" do
      @command.name.should eq "mv"
    end
  end

end

