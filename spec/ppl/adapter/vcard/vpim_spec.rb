
describe Ppl::Adapter::Vcard::Vpim, "#encode" do

  before(:each) do
    @adapter = Ppl::Adapter::Vcard::Vpim.new
    @contact = Ppl::Entity::Contact.new

    @contact.name = Ppl::Entity::Name.new
    @contact.name.given = "Minimum"
  end

  it "should encode the contact's birthday" do
    @contact.birthday = Date.parse "2000-01-01"
    @adapter.encode(@contact).should include("BDAY:20000101")
  end

  it "should encode the contact's name" do
    @contact.name.additional = "Johnny"
    @contact.name.full       = "John Doe"
    @contact.name.family     = "Doe"
    @contact.name.given      = "John"
    @contact.name.prefix     = "Mr."
    @contact.name.suffix     = "PhD"
    @adapter.encode(@contact).should include("N:Doe;John;Johnny;Mr.;PhD")
  end

  it "should encode the contact's full name" do
    @contact.name.full = "John Doe"
    @adapter.encode(@contact).should include("FN:John Doe")
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
      "END:VCARD",
    ].join("\n")
    @adapter.decode(vcard).should be_a(Ppl::Entity::Contact)
  end

  it "should decode the contact's birthday" do
    vcard = [
      "BEGIN:VCARD",
      "VERSION:3.0",
      "BDAY:20120102",
      "END:VCARD",
    ].join("\n")
    @adapter.decode(vcard).birthday.strftime('%Y-%m-%d').should eq "2012-01-02"
  end

  it "should decode the contact's email address" do
    vcard = [
      "BEGIN:VCARD",
      "VERSION:3.0",
      "EMAIL;TYPE=home:home@example.org",
      "END:VCARD",
    ].join("\n")
    contact = @adapter.decode(vcard)
    contact.email_addresses.first.address.should eq "home@example.org"
  end

end

