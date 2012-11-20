
describe Ppl::Command::ContactDelete do

  before(:each) do
    @command = Ppl::Command::ContactDelete.new
  end

  describe "#name" do
    it "should be 'rm'" do
      @command.name.should eq "rm"
    end
  end

end

