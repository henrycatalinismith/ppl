describe Ppl::Command::Org do

  before(:each) do
    @command = Ppl::Command::Org.new
  end

  describe "#name" do
    it "should be 'org'" do
      @command.name.should eq "org"
    end
  end

end

