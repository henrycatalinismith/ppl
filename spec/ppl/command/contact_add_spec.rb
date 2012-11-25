
describe Ppl::Command::ContactAdd do

  before(:each) do
    @command = Ppl::Command::ContactAdd.new
  end

  describe "#name" do
    it "should be 'add'" do
      @command.name.should eq "add"
    end
  end

end

