describe Ppl::Command::Nick do

  before(:each) do
    @command = Ppl::Command::Nick.new
  end

  describe "#name" do
    it "should be 'nick'" do
      @command.name.should eq "nick"
    end
  end

end

