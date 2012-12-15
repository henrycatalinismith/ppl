
describe Ppl::Format::AddressBook::EmailAddresses do

  before(:each) do
    @format       = Ppl::Format::AddressBook::EmailAddresses.new
    @address_book = Ppl::Entity::AddressBook.new
    @contact      = Ppl::Entity::Contact.new
    @table        = double(Ppl::Format::Table)

    @contact.id = "test"
    @format.table = @table

    @address_book.add_contact(@contact)
  end

  describe "#process" do

    it "should at least show the contact's id" do
      @table.should_receive(:add_row).with({
        :id            => "test:",
        :email_address => nil,
      })
      @format.process(@address_book)
    end

    it "should show the email address if it's available" do
      @contact.email_address = "jdoe@example.org"
      @table.should_receive(:add_row).with({
        :id            => "test:",
        :email_address => "jdoe@example.org",
      })
      @format.process(@address_book)
    end

  end

end

