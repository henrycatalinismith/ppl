describe Ppl::Format::AddressBook::Ages do
  describe "#initialize" do
    it "should pass the colors through to the table" do
      colors = {"id" => "blue"}
      expect(Ppl::Format::Table).to receive(:new).with([:id, :age], colors)
      format = Ppl::Format::AddressBook::Ages.new(colors)
    end
  end
end

describe Ppl::Format::AddressBook::Ages do

  before(:each) do
    @format       = Ppl::Format::AddressBook::Ages.new
    @address_book = Ppl::Entity::AddressBook.new
    @contact      = Ppl::Entity::Contact.new
    @table        = double(Ppl::Format::Table)
    @contact.id   = "test"
    @format.table = @table
    @format.date  = Date.parse("1980-01-02")
    @address_book.contacts.push(@contact)
  end

  describe "#process" do

    it "should at least show the contact's id" do
      expect(@table).to receive(:add_row).with({
        :id  => "test:",
        :age => "",
      })
      @format.process(@address_book)
    end

    it "should show an age if it's available" do
      @contact.birthday = Date.parse("1970-01-01")
      expect(@table).to receive(:add_row).with({
        :id  => "test:",
        :age => "10",
      })
      @format.process(@address_book)
    end

  end

end

