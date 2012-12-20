
describe Ppl::Entity::PostalAddress do

  before(:each) do
    @address = Ppl::Entity::PostalAddress.new
  end

  describe "#street" do
    it "should return a value" do
      @address.street.should be nil
    end
  end

end

