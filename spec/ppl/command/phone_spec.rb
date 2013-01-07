
describe Ppl::Command::Phone do

  before(:each) do
    @command = Ppl::Command::Phone.new
  end

  describe "#name" do
    it "should be 'phone'" do
      @command.name.should eq "phone"
    end
  end

end

