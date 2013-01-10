
describe Ppl::Format::AddressBook::Organizations do

  before(:each) do
    @format       = Ppl::Format::AddressBook::Organizations.new
    @address_book = Ppl::Entity::AddressBook.new
    @contact      = Ppl::Entity::Contact.new
    @table        = double(Ppl::Format::Table)

    @contact.id = "test"
    @format.table = @table

    @address_book.contacts.push(@contact)
  end

  describe "#process" do

    it "should at least show the contact's id" do
      @table.should_receive(:add_row).with({
        :id            => "test:",
        :organizations => "",
      })
      @format.process(@address_book)
    end

    it "should show the organization if it's available" do
      @contact.organizations.push("Example Ltd")
      @table.should_receive(:add_row).with({
        :id            => "test:",
        :organizations => "Example Ltd",
      })
      @format.process(@address_book)
    end

  end

end

