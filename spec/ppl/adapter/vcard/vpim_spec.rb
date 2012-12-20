
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
    @contact.email_address = "john@example.org"
    @adapter.encode(@contact).should include("EMAIL:john@example.org")
  end

  it "should encode the contact's phone number" do
    @contact.phone_number = "01234567890"
    @adapter.encode(@contact).should include("TEL:01234567890")
  end

  it "should encode the contact's organization" do
    @contact.organization = "Example Ltd"
    @adapter.encode(@contact).should include("ORG:Example Ltd")
  end

  it "should encode the contact's street address" do
    @contact.postal_address = Ppl::Entity::PostalAddress.new
    @contact.postal_address.street = "1 Testing Road"
    @adapter.encode(@contact).should include("ADR:;;1 Testing Road;;;;")
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
    contact.email_address.should eq "home@example.org"
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
    contact.phone_number.should eq "01234567890"
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
    contact.organization.should eq "Example Ltd"
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

end

