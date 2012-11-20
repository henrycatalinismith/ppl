
describe Ppl::Command::ContactList do

  before(:each) do
    @command = Ppl::Command::ContactList.new
  end

  describe "#name" do
    it "should be 'ls'" do
      @command.name.should eq "ls"
    end
  end

end

