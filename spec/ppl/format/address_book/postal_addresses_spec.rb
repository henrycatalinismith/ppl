describe Ppl::Format::AddressBook::PostalAddresses do
  describe "#initialize" do
    it "should pass the colors through to the table" do
      colors = {"id" => "blue"}
      expect(Ppl::Format::Table).to receive(:new).with([:id, :address_ids], colors)
      format = Ppl::Format::AddressBook::PostalAddresses.new(colors)
    end
  end
end

describe Ppl::Format::AddressBook::PostalAddresses do

  before(:each) do
    @format       = Ppl::Format::AddressBook::PostalAddresses.new
    @address_book = Ppl::Entity::AddressBook.new
    @contact      = Ppl::Entity::Contact.new
    @address      = Ppl::Entity::PostalAddress.new
    @table        = double(Ppl::Format::Table)

    @address.id = "home"
    @contact.id = "test"
    @contact.postal_addresses << @address
    @format.table = @table

    @address_book.contacts.push(@contact)
  end

  describe "#process" do

    it "shows the contact's and address' IDs" do
      expect(@table).to receive(:add_row).with({
        :id          => "test:",
        :address_ids => "home",
      })
      @format.process(@address_book)
    end

  end

end

