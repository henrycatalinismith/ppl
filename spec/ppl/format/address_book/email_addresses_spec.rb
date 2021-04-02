describe Ppl::Format::AddressBook::EmailAddresses do
  describe "#initialize" do
    it "should pass the colors through to the table" do
      colors = {"id" => "blue"}
      expect(Ppl::Format::Table).to receive(:new).with([:id, :email_addresses], colors)
      format = Ppl::Format::AddressBook::EmailAddresses.new(colors)
    end
  end
end

describe Ppl::Format::AddressBook::EmailAddresses do

  before(:each) do
    @format       = Ppl::Format::AddressBook::EmailAddresses.new
    @address_book = Ppl::Entity::AddressBook.new
    @contact      = Ppl::Entity::Contact.new
    @table        = double(Ppl::Format::Table)

    @contact.id = "test"
    @format.table = @table

    @address_book.contacts.push(@contact)
  end

  describe "#process" do

    it "should at least show the contact's id" do
      expect(@table).to receive(:add_row).with({
        :id              => "test:",
        :email_addresses => "",
      })
      @format.process(@address_book)
    end

    it "should show an email address if it's available" do
      @contact.email_addresses << Ppl::Entity::EmailAddress.new("jdoe@example.org")
      expect(@table).to receive(:add_row).with({
        :id              => "test:",
        :email_addresses => "jdoe@example.org",
      })
      @format.process(@address_book)
    end

  end

end

