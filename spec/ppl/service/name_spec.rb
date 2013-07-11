
describe Ppl::Service::Name do

  before(:each) do
    @service = Ppl::Service::Name.new
  end

  describe "#parse" do

    it "uses the whole string for the full name" do
      @service.parse("John Smith").full.should eq "John Smith"
    end

  end

end

