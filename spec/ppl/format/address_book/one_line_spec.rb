
describe Ppl::Format::AddressBook::OneLine do

  before(:each) do
    @format       = Ppl::Format::AddressBook::OneLine.new
    @address_book = Ppl::Entity::AddressBook.new
    @contact      = Ppl::Entity::Contact.new

    @contact.id = "test"

    @address_book.add_contact(@contact)
  end

  describe "#process" do

    it "should at least show the contact's id" do
      @format.process(@address_book).should include "test:"
    end

    it "should show the contact's name if available" do
      @contact.name = "John Doe"
      @format.process(@address_book).should include "John Doe"
    end

    it "should show the contact's email address if available" do
      @contact.email_address = "john@example.org"
      @format.process(@address_book).should include "<john@example.org>"
    end

    it "should show their name and email if possible" do
      @contact.name          = "John Doe"
      @contact.email_address = "john@example.org"
      @format.process(@address_book).should include "John Doe <john@example.org>"
    end

  end

end

