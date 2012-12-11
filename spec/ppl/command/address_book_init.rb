
describe Ppl::Command::CommandList do

  before(:each) do
    @command = Ppl::Command::AddressBookInit.new
  end

  describe "#name" do
    it "should be 'init'" do
      @command.name.should eq "init"
    end
  end

  describe "#execute" do

    it "should " do
    end

  end

end

