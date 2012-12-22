
describe Ppl::Format::Contact::Full do

  before(:each) do
    @format  = Ppl::Format::Contact::Full.new
    @contact = Ppl::Entity::Contact.new
    @address = Ppl::Entity::PostalAddress.new

    @postal_address_format = double(Ppl::Format::Contact)
    @format.postal_address_format = @postal_address_format
  end

  describe "#process" do

    it "should return an empty string if the contact lacks any properties" do
      @format.process(Ppl::Entity::Contact.new).should eq ""
    end

    it "should start with the contact's name" do
      @contact.name = "John Doe"
      @format.process(@contact).should eq "John Doe"
    end

    it "should include their email address in brackets" do
      @contact.name = "John Doe"
      @contact.email_addresses.push "john@example.org"
      @format.process(@contact).should eq "John Doe <john@example.org>"
    end

    it "should show their birthday if available" do
      @contact.birthday = Date.parse("1980-01-01")
      @format.process(@contact).should include "1980-01-01"
    end

    it "should show their phone number if available" do
      @contact.phone_number = "01234567890"
      @format.process(@contact).should include "01234567890"
    end

    it "should show their organization if available" do
      @contact.organization = "Example Ltd"
      @format.process(@contact).should include "Example Ltd"
    end

    it "should show their postal address if available" do
      @contact.postal_address = @address
      @postal_address_format.should_receive(:process).with(@contact)
      @format.process(@contact)
    end

  end

end

