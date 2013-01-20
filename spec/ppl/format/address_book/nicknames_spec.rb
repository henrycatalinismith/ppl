
describe Ppl::Format::AddressBook::Nicknames do

  before(:each) do
    @format       = Ppl::Format::AddressBook::Nicknames.new
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
        :id        => "test:",
        :nicknames => "",
      })
      @format.process(@address_book)
    end

    it "should show a nickname if it's available" do
      @contact.nicknames.push("Stupid")
      @table.should_receive(:add_row).with({
        :id        => "test:",
        :nicknames => "Stupid",
      })
      @format.process(@address_book)
    end

  end

end

