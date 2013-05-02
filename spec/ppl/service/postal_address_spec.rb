
describe Ppl::Service::PostalAddress do

  before(:each) do
    @service = Ppl::Service::PostalAddress.new
    @contact = Ppl::Entity::Contact.new
  end

  describe "#add" do

    before(:each) do
      @service.add(@contact, {
        :country     => "United Kingdom",
        :locality    => "Bristol",
        :street      => "1 Broad Mead",
        :po_box      => "550011",
        :postal_code => "BS1 1SB",
        :region      => "South West",
      })
      @address = @contact.postal_addresses.first
    end

    it "adds one postal address to the contact" do
      @contact.postal_addresses.length.should eq 1
    end

    it "sets the country of the new address" do
      @address.country.should eq "United Kingdom"
    end
    it "sets the locality of the new address" do
      @address.locality.should eq "Bristol"
    end
    it "sets the street of the new address" do
      @address.street.should eq "1 Broad Mead"
    end
    it "sets the PO box of the new address" do
      @address.po_box.should eq "550011"
    end
    it "sets the postal code of the new address" do
      @address.postal_code.should eq "BS1 1SB"
    end
    it "sets the region of the new address" do
      @address.region.should eq "South West"
    end
  end

end

