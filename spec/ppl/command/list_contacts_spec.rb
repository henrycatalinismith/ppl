
describe Ppl::Command::ListContacts do

  before(:each) do
    @command = Ppl::Command::ListContacts.new
  end

  describe "#name" do
    it "should be 'ls'" do
      @command.name.should eq "ls"
    end
  end

end

