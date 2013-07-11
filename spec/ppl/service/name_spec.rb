
describe Ppl::Service::Name do

  before(:each) do
    @service = Ppl::Service::Name.new
  end

  describe "#parse" do

    it "uses the whole string for the full name" do
      @service.parse("John Smith").full.should eq "John Smith"
    end

    it "uses the first word for the given name" do
      @service.parse("John Smith").given.should eq "John"
    end

    it "uses the rest of the string for the family names" do
      @service.parse("John Fitzgerald Donald Smith").family.should eq "Fitzgerald Donald Smith"
    end

  end

end

