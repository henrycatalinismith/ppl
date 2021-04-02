describe Ppl::Format::Contact::PostalAddresses do
  describe "#initialize" do
    it "should pass the colors through to the table" do
      colors = {"address_id" => "blue"}
      Ppl::Format::Table.should_receive(:new).with([:star, :address_id, :address_text], colors)
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
      @pa_fmt.should_receive(:process).with(@address, @table)
      @table.should_receive(:to_s)
      @format.process(@contact)
    end

  end

end

