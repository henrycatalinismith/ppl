describe Ppl::Format::AddressBook::MuttQuery do

  before(:each) do
    @format       = Ppl::Format::AddressBook::MuttQuery.new
    @address_book = Ppl::Entity::AddressBook.new
    @contact      = Ppl::Entity::Contact.new
    @table        = double(Ppl::Format::Table)

    @contact.email_addresses << Ppl::Entity::EmailAddress.new("test@example.org")
    @contact.name = "Test Contact"

    @format.table = @table
    @address_book.contacts.push(@contact)
  end

  describe "#process" do

    it "should list the given contacts" do
      @table.should_receive(:add_row).with({
        :email => "test@example.org",
        :name  => "Test Contact",
      })
      @format.process(@address_book)
    end

    it "should list all of each contact's email addresses" do
      @contact.email_addresses << Ppl::Entity::EmailAddress.new("test2@example.com")
      @table.should_receive(:add_row).with({
        :email => "test@example.org",
        :name  => "Test Contact",
      })
      @table.should_receive(:add_row).with({
        :email => "test2@example.com",
        :name  => "Test Contact",
      })
      @format.process(@address_book)
    end

  end

end

