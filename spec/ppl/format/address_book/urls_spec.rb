
describe Ppl::Format::AddressBook::Urls do

  before(:each) do
    @format       = Ppl::Format::AddressBook::Urls.new
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
        :urls => nil,
      })
      @format.process(@address_book)
    end

    it "should show a URL if it's available" do
      @contact.urls.push "http://example.org/~jdoe"
      @table.should_receive(:add_row).with({
        :id   => "test:",
        :urls => "http://example.org/~jdoe",
      })
      @format.process(@address_book)
    end

  end

end

