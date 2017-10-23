# encoding: utf-8

describe Ppl::Adapter::Vcard::Vpim, "#encode" do

  before(:each) do
    @adapter = Ppl::Adapter::Vcard::Vpim.new
    @contact = Ppl::Entity::Contact.new
    @contact.name = Ppl::Entity::Name.new
    @contact.id = "test"
  end

  it "should encode the contact's birthday" do
    @contact.birthday = Date.parse "2000-01-01"
    @adapter.encode(@contact).should include("BDAY:20000101")
  end

  it "should encode the contact's full name" do
    @contact.name.full = "John Doe"
    @adapter.encode(@contact).should include("FN:John Doe")
  end

  it "should encode the contact's given name" do
    @contact.name.given = "John"
    @adapter.encode(@contact).should include("N:;John;;;")
  end

  it "should encode the contact's family name" do
    @contact.name.family = "Smith"
    @adapter.encode(@contact).should include("N:Smith;;;;")
  end

  it "should encode the contact's middle name" do
    @contact.name.middle = "Quentin"
    @adapter.encode(@contact).should include("N:;;Quentin;;")
  end

  it "should encode the contact's name prefix" do
    @contact.name.prefix = "Mr."
    @adapter.encode(@contact).should include("N:;;;Mr.;")
  end

  it "should encode the contact's name suffix" do
    @contact.name.suffix = "BSc"
    @adapter.encode(@contact).should include("N:;;;;BSc")
  end

  it "should encode the contact's email address" do
    @contact.email_addresses << Ppl::Entity::EmailAddress.new("john@example.org")
    @adapter.encode(@contact).should include("EMAIL:john@example.org")
  end

  it "should encode the contact's preferred email address as such" do
    email_address = Ppl::Entity::EmailAddress.new("john@example.org")
    email_address.preferred = true
    @contact.email_addresses << email_address
    @adapter.encode(@contact).should include("EMAIL;TYPE=pref:john@example.org")
  end

  it "should encode the contact's phone number" do
    @contact.phone_numbers << Ppl::Entity::PhoneNumber.new("01234567890")
    @adapter.encode(@contact).should include("TEL:01234567890")
  end

  it "should encode the contact's preferred phone number as such" do
    @contact.phone_numbers << Ppl::Entity::PhoneNumber.new("01234567890")
    @contact.phone_numbers[0].preferred = true
    @adapter.encode(@contact).should include("TEL;TYPE=pref:01234567890")
  end

  it "should encode the contact's phone number's type" do
    @contact.phone_numbers << Ppl::Entity::PhoneNumber.new("01234567890", "cell")
    @adapter.encode(@contact).should include("TEL;TYPE=cell:01234567890")
  end

  it "should encode the contact's organization" do
    @contact.organizations.push("Example Ltd")
    @adapter.encode(@contact).should include("ORG:Example Ltd")
  end

  describe "postal address encoding" do

    before(:each) do
      @address = Ppl::Entity::PostalAddress.new
      @contact.postal_addresses << @address
    end

    it "should encode the address id" do
      @contact.postal_addresses[0].id = "home"
      @adapter.encode(@contact).should include("ADR;TYPE=home:;;;;;;")
    end

    it "should encode the preferred status of the address" do
      @contact.postal_addresses[0].preferred = true
      @adapter.encode(@contact).should include("ADR;TYPE=pref:;;;;;;")
    end

    it "should encode the contact's street address" do
      @contact.postal_addresses[0].street = "1 Testing Road"
      @adapter.encode(@contact).should include("ADR:;;1 Testing Road;;;;")
    end

    it "should encode the contact's postal code" do
      @contact.postal_addresses[0].postal_code = "L7 8AA"
      @adapter.encode(@contact).should include("ADR:;;;;;L7 8AA;")
    end

    it "should encode the contact's po box" do
      @contact.postal_addresses[0].po_box = "123456"
      @adapter.encode(@contact).should include("ADR:123456;;;;;;")
    end

    it "should encode the contact's locality" do
      @contact.postal_addresses[0].locality = "Liverpool"
      @adapter.encode(@contact).should include("ADR:;;;Liverpool;;;")
    end

    it "should encode the contact's country" do
      @contact.postal_addresses[0].country = "UK"
      @adapter.encode(@contact).should include("ADR:;;;;;;UK")
    end

    it "should encode the contact's region" do
      @contact.postal_addresses[0].region = "South West"
      @adapter.encode(@contact).should include("ADR:;;;;South West;;")
    end

  end

  it "should encode the contact's URL" do
    @contact.urls.push "http://google.com"
    @adapter.encode(@contact).should include("URL:http://google.com")
  end

  it "should encode the contact's nickname" do
    @contact.nicknames.push "Sleepy"
    @adapter.encode(@contact).should include("NICKNAME:Sleepy")
  end

end


describe Ppl::Adapter::Vcard::Vpim, "#decode" do

  before(:each) do
    @adapter = Ppl::Adapter::Vcard::Vpim.new
  end

  it "should return a Ppl::Entity::Contact" do
    vcard = [
      "BEGIN:VCARD",
      "VERSION:3.0",
      "N:,test",
      "END:VCARD",
    ].join("\n")
    @adapter.decode(vcard).should be_a(Ppl::Entity::Contact)
  end

  it "should decode the contact's birthday" do
    vcard = [
      "BEGIN:VCARD",
      "VERSION:3.0",
      "N:,test",
      "BDAY:20120102",
      "END:VCARD",
    ].join("\n")
    @adapter.decode(vcard).birthday.strftime('%Y-%m-%d').should eq "2012-01-02"
  end

  it "should decode the contact's name" do

    vcard = [
      "BEGIN:VCARD",
      "VERSION:3.0",
      "N:,test",
      "FN:John Doe",
      "END:VCARD",
    ].join("\n")
    contact = @adapter.decode(vcard)

    contact.name.full.should eq "John Doe"
  end

  it "should decode the contact's email address" do
    vcard = [
      "BEGIN:VCARD",
      "N:,test",
      "VERSION:3.0",
      "EMAIL;TYPE=home:home@example.org",
      "END:VCARD",
    ].join("\n")
    contact = @adapter.decode(vcard)
    contact.email_addresses.first.address.should eq "home@example.org"
  end

  it "should mark preferred email addresses as such" do
    vcard = [
      "BEGIN:VCARD",
      "N:,test",
      "VERSION:3.0",
      "EMAIL;PREF:home@example.org",
      "END:VCARD",
    ].join("\n")
    contact = @adapter.decode(vcard)
    contact.email_addresses.first.preferred.should eq true
  end

  it "should decode the contact's phone number" do
    vcard = [
      "BEGIN:VCARD",
      "N:,test",
      "VERSION:3.0",
      "TEL:01234567890",
      "END:VCARD",
    ].join("\n")
    contact = @adapter.decode(vcard)
    phone_number = contact.phone_numbers.first
    phone_number.number.should eq "01234567890"
  end

  it "should mark preferred phone numbers as such" do
    vcard = [
      "BEGIN:VCARD",
      "N:,test",
      "VERSION:3.0",
      "TEL;TYPE=pref:01234567890",
      "END:VCARD",
    ].join("\n")
    contact = @adapter.decode(vcard)
    phone_number = contact.phone_numbers.first
    phone_number.preferred.should eq true
  end

  it "should decode the contact's phone number's type" do
    vcard = [
      "BEGIN:VCARD",
      "N:,test",
      "VERSION:3.0",
      "TEL;TYPE=cell:01234567890",
      "END:VCARD",
    ].join("\n")
    contact = @adapter.decode(vcard)
    phone_number = contact.phone_numbers.first
    phone_number.type.should eq "cell"
  end

  it "should decode the contact's phone number's nonstandard type" do
    vcard = [
      "BEGIN:VCARD",
      "N:,test",
      "VERSION:3.0",
      "TEL;TYPE=testing:01234567890",
      "END:VCARD",
    ].join("\n")
    contact = @adapter.decode(vcard)
    phone_number = contact.phone_numbers.first
    phone_number.type.should eq "testing"
  end

  it "should decode the contact's organization" do
    vcard = [
      "BEGIN:VCARD",
      "N:,test",
      "VERSION:3.0",
      "ORG:Example Ltd",
      "END:VCARD",
    ].join("\n")
    contact = @adapter.decode(vcard)
    contact.organizations.first.should eq "Example Ltd"
  end

  describe "postal address decoding" do

    it "should decode the postal address' ID" do
      vcard = [
        "BEGIN:VCARD",
        "N:,test",
        "VERSION:3.0",
        "ADR;TYPE=home:;;1 Testing Road;;;;",
        "END:VCARD",
      ].join("\n")
      contact = @adapter.decode(vcard)
      contact.postal_addresses[0].id.should eq "home"
    end

    it "should decode the postal address' ID even if it's a nonstandard type" do
      vcard = [
        "BEGIN:VCARD",
        "N:,test",
        "VERSION:3.0",
        "ADR;TYPE=nasa:;;1 Testing Road;;;;",
        "END:VCARD",
      ].join("\n")
      contact = @adapter.decode(vcard)
      contact.postal_addresses[0].id.should eq "nasa"
    end

    it "should assign the postal address a fallback ID if necessary" do
      vcard = [
        "BEGIN:VCARD",
        "N:,test",
        "VERSION:3.0",
        "ADR:;;1 Testing Road;;;;",
        "END:VCARD",
      ].join("\n")
      contact = @adapter.decode(vcard)
      contact.postal_addresses[0].id.should eq "910c67f"
    end

    it "should decode the contact's street address" do
      vcard = [
        "BEGIN:VCARD",
        "N:,test",
        "VERSION:3.0",
        "ADR:;;1 Testing Road;;;;",
        "END:VCARD",
      ].join("\n")
      contact = @adapter.decode(vcard)
      contact.postal_addresses[0].street.should eq "1 Testing Road"
    end

    it "should decode the contact's postal code" do
      vcard = [
        "BEGIN:VCARD",
        "N:,test",
        "VERSION:3.0",
        "ADR:;;;;;L7 8AA;",
        "END:VCARD",
      ].join("\n")
      contact = @adapter.decode(vcard)
      contact.postal_addresses[0].postal_code.should eq "L7 8AA"
    end

    it "should decode the contact's po box" do
      vcard = [
        "BEGIN:VCARD",
        "N:,test",
        "VERSION:3.0",
        "ADR:123456;;;;;;",
        "END:VCARD",
      ].join("\n")
      contact = @adapter.decode(vcard)
      contact.postal_addresses[0].po_box.should eq "123456"
    end

    it "should decode the contact's locality" do
      vcard = [
        "BEGIN:VCARD",
        "N:,test",
        "VERSION:3.0",
        "ADR:;;;Liverpool;;;",
        "END:VCARD",
      ].join("\n")
      contact = @adapter.decode(vcard)
      contact.postal_addresses[0].locality.should eq "Liverpool"
    end

    it "should decode the contact's region" do
      vcard = [
        "BEGIN:VCARD",
        "N:,test",
        "VERSION:3.0",
        "ADR:;;;;South West;;",
        "END:VCARD",
      ].join("\n")
      contact = @adapter.decode(vcard)
      contact.postal_addresses[0].region.should eq "South West"
    end

    it "should decode the contact's country" do
      vcard = [
        "BEGIN:VCARD",
        "N:,test",
        "VERSION:3.0",
        "ADR:;;;;;;UK",
        "END:VCARD",
      ].join("\n")
      contact = @adapter.decode(vcard)
      contact.postal_addresses[0].country.should eq "UK"
    end

  end

  it "should decode the contact's URL" do
    vcard = [
      "BEGIN:VCARD",
      "N:,test",
      "VERSION:3.0",
      "URL:http://google.com",
      "END:VCARD",
    ].join("\n")
    contact = @adapter.decode(vcard)
    contact.urls.first.should eq "http://google.com"
  end

  it "should decode the contact's nickame" do
    vcard = [
      "BEGIN:VCARD",
      "N:,test",
      "VERSION:3.0",
      "NICKNAME:Happy;Cheerful",
      "END:VCARD",
    ].join("\n")
    contact = @adapter.decode(vcard)
    contact.nicknames.first.should eq "Happy"
  end

  it "should not choke on utf8" do
    vcard = [
      "BEGIN:VCARD",
      "VERSION:3.0",
      "N:;Straße;;;",
      "FN:Straße",
      "END:VCARD",
    ].join("\n")
    contact = @adapter.decode(vcard)
    contact.name.full.should eq "Straße"
  end

end

