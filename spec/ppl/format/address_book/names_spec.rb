
describe Ppl::Format::AddressBook::Names do

  before(:each) do
    @format       = Ppl::Format::AddressBook::Names.new
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
        :id   => "test:",
        :name => nil,
      })
      @format.process(@address_book)
    end

    it "should show the name if it's available" do
      @contact.name = "John Doe"
      @table.should_receive(:add_row).with({
        :id   => "test:",
        :name => "John Doe",
      })
      @format.process(@address_book)
    end

  end

end

