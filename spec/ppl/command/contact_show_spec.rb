
describe Ppl::Command::ContactShow do

  before(:each) do
    @command = Ppl::Command::ContactShow.new
  end

  describe "#name" do
    it "should be 'show'" do
      @command.name.should eq "show"
    end
  end

end

