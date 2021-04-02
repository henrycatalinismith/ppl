describe Ppl::Entity::PostalAddress do

  before(:each) do
    @address = Ppl::Entity::PostalAddress.new
  end

  describe "#preferred" do
    it "should be false by default" do
      @address.preferred.should eq false
    end
  end

  describe "#street" do
    it "should return a value" do
      @address.street.should be nil
    end
  end

end

