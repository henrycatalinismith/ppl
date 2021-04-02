describe Ppl::Format::AddressBook::Urls do
  describe "#initialize" do
    it "should pass the colors through to the table" do
      colors = {"id" => "blue"}
      expect(Ppl::Format::Table).to receive(:new).with([:id, :urls], colors)
      format = Ppl::Format::AddressBook::Urls.new(colors)
    end
  end
end

describe Ppl::Format::AddressBook::Urls do

  before(:each) do
    @format       = Ppl::Format::AddressBook::Urls.new
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
        :id   => "test:",
        :urls => "",
      })
      @format.process(@address_book)
    end

    it "should show a URL if it's available" do
      @contact.urls.push "http://example.org/~jdoe"
      expect(@table).to receive(:add_row).with({
        :id   => "test:",
        :urls => "http://example.org/~jdoe",
      })
      @format.process(@address_book)
    end

  end

end

