
describe Ppl::Adapter::Vcard::Vpim, "#encode" do

  before(:each) do
    @adapter = Ppl::Adapter::Vcard::Vpim.new
    @contact = Ppl::Entity::Contact.new
    @contact.id = "test"
  end

  it "should encode the contact's birthday" do
    @contact.birthday = Date.parse "2000-01-01"
    @adapter.encode(@contact).should include("BDAY:20000101")
  end

  it "should encode the contact's name" do
    @contact.name = "John Doe"
    @adapter.encode(@contact).should include("FN:John Doe")
  end

  it "should encode the contact's email address" do
    @contact.email_addresses = ["john@example.org"]
    @adapter.encode(@contact).should include("EMAIL:john@example.org")
  end

  it "should encode the contact's phone number" do
    @contact.phone_numbers.push("01234567890")
    @adapter.encode(@contact).should include("TEL:01234567890")
  end

  it "should encode the contact's organization" do
    @contact.organizations.push("Example Ltd")
    @adapter.encode(@contact).should include("ORG:Example Ltd")
  end

  it "should encode the contact's street address" do
    @contact.postal_address = Ppl::Entity::PostalAddress.new
    @contact.postal_address.street = "1 Testing Road"
    @adapter.encode(@contact).should include("ADR:;;1 Testing Road;;;;")
  end

  it "should encode the contact's postal code" do
    @contact.postal_address = Ppl::Entity::PostalAddress.new
    @contact.postal_address.postal_code = "L7 8AA"
    @adapter.encode(@contact).should include("ADR:;;;;;L7 8AA;")
  end

  it "should encode the contact's po box" do
    @contact.postal_address = Ppl::Entity::PostalAddress.new
    @contact.postal_address.po_box = "123456"
    @adapter.encode(@contact).should include("ADR:123456;;;;;;")
  end

  it "should encode the contact's locality" do
    @contact.postal_address = Ppl::Entity::PostalAddress.new
    @contact.postal_address.locality = "Liverpool"
    @adapter.encode(@contact).should include("ADR:;;;Liverpool;;;")
  end

  it "should encode the contact's country" do
    @contact.postal_address = Ppl::Entity::PostalAddress.new
    @contact.postal_address.country = "UK"
    @adapter.encode(@contact).should include("ADR:;;;;;;UK")
  end

  it "should encode the contact's region" do
    @contact.postal_address = Ppl::Entity::PostalAddress.new
    @contact.postal_address.region = "South West"
    @adapter.encode(@contact).should include("ADR:;;;;South West;;")
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

    contact.name.should eq "John Doe"
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
    contact.email_addresses.first.should eq "home@example.org"
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
    contact.phone_numbers.first.should eq "01234567890"
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

  it "should decode the contact's street address" do
    vcard = [
      "BEGIN:VCARD",
      "N:,test",
      "VERSION:3.0",
      "ADR:;;1 Testing Road;;;;",
      "END:VCARD",
    ].join("\n")
    contact = @adapter.decode(vcard)
    contact.postal_address.street.should eq "1 Testing Road"
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
    contact.postal_address.postal_code.should eq "L7 8AA"
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
    contact.postal_address.po_box.should eq "123456"
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
    contact.postal_address.locality.should eq "Liverpool"
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
    contact.postal_address.region.should eq "South West"
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
    contact.postal_address.country.should eq "UK"
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
      "NICKNAME:Happy",
      "END:VCARD",
    ].join("\n")
    contact = @adapter.decode(vcard)
    contact.nicknames.first.should eq "Happy"
  end

end

