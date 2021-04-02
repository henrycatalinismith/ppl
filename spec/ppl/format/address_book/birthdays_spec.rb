describe Ppl::Format::AddressBook::Birthdays do
  describe "#initialize" do
    it "should pass the colors through to the table" do
      colors = {"id" => "blue"}
      expect(Ppl::Format::Table).to receive(:new).with([:id, :birthday], colors)
      format = Ppl::Format::AddressBook::Birthdays.new(colors)
    end
  end
end

describe Ppl::Format::AddressBook::Birthdays do

  before(:each) do
    @format       = Ppl::Format::AddressBook::Birthdays.new
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
        :id       => "test:",
        :birthday => nil,
      })
      @format.process(@address_book)
    end

    it "should show the birthday if it's available" do
      @contact.birthday = Date.parse("2001-02-03")
      expect(@table).to receive(:add_row).with({
        :id        => "test:",
        :birthday  => "2001-02-03",
      })
      @format.process(@address_book)
    end

  end

end

