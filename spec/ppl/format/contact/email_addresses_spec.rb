describe Ppl::Format::Contact::EmailAddresses do
  describe "#initialize" do
    it "should pass the colors through to the table" do
      colors = {"id" => "blue"}
      Ppl::Format::Table.should_receive(:new).with([:star, :email_addresses], colors)
      format = Ppl::Format::Contact::EmailAddresses.new(colors)
    end
  end
end

describe Ppl::Format::Contact::EmailAddresses do

  before(:each) do
    @format  = Ppl::Format::Contact::EmailAddresses.new
    @contact = Ppl::Entity::Contact.new
    @email   = Ppl::Entity::EmailAddress.new("test@example.org")
    @table   = double(Ppl::Format::Table)
    @format.table = @table
    @contact.email_addresses << @email
  end

  describe "#process" do

    it "should pass each email address to the table" do
      @table.should_receive(:add_row).with({
        :star            => " ",
        :email_addresses => "test@example.org",
      })
      @format.process(@contact)
    end

    it "should mark the preferred email with a star" do
      @email.preferred = true
      @table.should_receive(:add_row).with({
        :star            => "*",
        :email_addresses => "test@example.org",
      })
      @format.process(@contact)
    end

  end

end

