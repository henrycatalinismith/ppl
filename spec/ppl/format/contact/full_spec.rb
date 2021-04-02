describe Ppl::Format::Contact::Full do

  before(:each) do
    @format  = Ppl::Format::Contact::Full.new
    @contact = Ppl::Entity::Contact.new
    @address = Ppl::Entity::PostalAddress.new

    @email_address_format = double(Ppl::Format::Contact)
    @phone_number_format = double(Ppl::Format::Contact)
    @postal_address_format = double(Ppl::Format::Contact)
    @format.email_address_format = @email_address_format
    @format.phone_number_format = @phone_number_format
    @format.postal_address_format = @postal_address_format

    allow(@email_address_format).to receive(:process)
  end

  describe "#process" do

    it "should return an empty string if the contact lacks any properties" do
      expect(@format.process(Ppl::Entity::Contact.new)).to eq ""
    end

    it "should start with the contact's name" do
      @contact.name = Ppl::Entity::Name.new
      @contact.name.full = "John Doe"
      expect(@format.process(@contact)).to eq "John Doe"
    end

    it "should include their email address in brackets" do
      @contact.name = Ppl::Entity::Name.new
      @contact.name.full = "John Doe"
      @contact.email_addresses << Ppl::Entity::EmailAddress.new("john@example.org")
      expect(@format.process(@contact)).to include "John Doe <john@example.org>"
    end

    it "should include their preferred email address in brackets" do
      @contact.name = Ppl::Entity::Name.new
      @contact.name.full = "John Doe"
      @contact.email_addresses << Ppl::Entity::EmailAddress.new("john@example.org")
      @contact.email_addresses << Ppl::Entity::EmailAddress.new("fred@testtest.es")
      @contact.email_addresses[1].preferred = true
      expect(@format.process(@contact)).to include "John Doe <fred@testtest.es>"
    end

    it "should invoke the email address formatter if there are any addresses" do
      @contact.email_addresses << Ppl::Entity::EmailAddress.new("john@example.net")
      expect(@email_address_format).to receive(:process).with(@contact)
      @format.process(@contact)
    end

    it "should invoke the phone number formatter if there are any numbers" do
      @contact.phone_numbers << Ppl::Entity::PhoneNumber.new("01234567890")
      expect(@phone_number_format).to receive(:process).with(@contact)
      @format.process(@contact)
    end

    it "should show their birthday if available" do
      @contact.birthday = Date.parse("1980-01-01")
      expect(@format.process(@contact)).to include "1980-01-01"
    end

    it "should show all their organizations" do
      @contact.organizations.push("Example Ltd")
      expect(@format.process(@contact)).to include "Example Ltd"
    end

    it "should show their postal address if available" do
      @contact.postal_addresses << @address
      expect(@postal_address_format).to receive(:process).and_return("")
      @format.process(@contact)
    end

    it "should show all their URLs" do
      @contact.urls.push "http://example.org"
      expect(@format.process(@contact)).to include "http://example.org"
    end

  end

end

