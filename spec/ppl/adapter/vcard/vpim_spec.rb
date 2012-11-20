
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

