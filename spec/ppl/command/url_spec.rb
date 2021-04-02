describe Ppl::Command::Url do

  before(:each) do
    @command = Ppl::Command::Url.new
  end

  describe "#name" do
    it "should be 'url'" do
      @command.name.should eq "url"
    end
  end

end

