
describe Ppl::Format::AddressBook::OneLine do
  describe "#initialize" do
    it "should pass the colors through to the table" do
      colors = {"id" => "blue"}
      Ppl::Format::Table.should_receive(:new).with([:id, :name, :email], colors)
      format = Ppl::Format::AddressBook::OneLine.new(colors)
    end
  end
end

describe Ppl::Format::AddressBook::OneLine do

  before(:each) do
    @format       = Ppl::Format::AddressBook::OneLine.new
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
        :id    => "test:",
        :name  => nil,
        :email => nil,
      })
      @format.process(@address_book)
    end

    it "should show all the info if it's available" do
      @contact.name = "John Doe"
      @contact.email_addresses << Ppl::Entity::EmailAddress.new("jdoe@example.org")
      @table.should_receive(:add_row).with({
        :id    => "test:",
        :name  => "John Doe",
        :email => "<jdoe@example.org>",
      })
      @format.process(@address_book)
    end

  end

end

