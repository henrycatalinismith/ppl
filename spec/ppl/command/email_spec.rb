
describe Ppl::Command::Email do

  before(:each) do
    @command = Ppl::Command::Email.new
  end

  describe "#name" do
    it "should be 'email'" do
      @command.name.should eq "email"
    end
  end

end

