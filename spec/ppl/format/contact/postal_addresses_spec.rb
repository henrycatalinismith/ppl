describe Ppl::Format::Contact::PostalAddresses do
  describe "#initialize" do
    it "should pass the colors through to the table" do
      colors = {"address_id" => "blue"}
      expect(Ppl::Format::Table).to receive(:new).with([:star, :address_id, :address_text], colors)
      format = Ppl::Format::Contact::PostalAddresses.new(colors)
    end
  end
end

describe Ppl::Format::Contact::PostalAddresses do

  before(:each) do
    @format  = Ppl::Format::Contact::PostalAddresses.new
    @contact = Ppl::Entity::Contact.new
    @address = Ppl::Entity::PostalAddress.new
    @table   = double(Ppl::Format::Table)
    @pa_fmt  = double(Ppl::Format::PostalAddress)
    @format.table = @table
    @format.postal_address_format = @pa_fmt
  end

  describe "#process" do

    it "passes each postal address to the postal address formatter" do
      @contact.postal_addresses << @address
      expect(@pa_fmt).to receive(:process).with(@address, @table)
      expect(@table).to receive(:to_s)
      @format.process(@contact)
    end

  end

end

