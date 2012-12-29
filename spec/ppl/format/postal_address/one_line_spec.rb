
describe Ppl::Format::PostalAddress::OneLine do

  before(:each) do
    @format  = Ppl::Format::PostalAddress::OneLine.new
    @address = Ppl::Entity::PostalAddress.new
  end

  describe "#process" do

    it "should include the country if available" do
      @address.country = "UK"
      @format.process(@address).should include "UK"
    end

    it "should include the locality if available" do
      @address.locality = "Liverpool"
      @format.process(@address).should include "Liverpool"
    end

    it "should include the street if available" do
      @address.street = "1 Test Road"
      @format.process(@address).should include "1 Test Road"
    end

    it "should include the po box if available" do
      @address.po_box = "123456"
      @format.process(@address).should include "123456"
    end

    it "should include the postal code if available" do
      @address.postal_code = "L1 9AA"
      @format.process(@address).should include "L1 9AA"
    end

    it "should include the region if available" do
      @address.region = "Merseyside"
      @format.process(@address).should include "Merseyside"
    end

  end

end

