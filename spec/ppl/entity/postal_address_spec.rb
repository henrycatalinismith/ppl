describe Ppl::Entity::PostalAddress do

  before(:each) do
    @address = Ppl::Entity::PostalAddress.new
  end

  describe "#preferred" do
    it "should be false by default" do
      expect(@address.preferred).to eq false
    end
  end

  describe "#street" do
    it "should return a value" do
      expect(@address.street).to be nil
    end
  end

end

