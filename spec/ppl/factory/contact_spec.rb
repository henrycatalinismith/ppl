
describe Ppl::Factory::Contact, "#load_contact" do

  before(:each) do
    @factory = Ppl::Factory::Contact.new
  end

  it "returns a Ppl::Entity::Contact" do
    contact = @factory.load_contact(1)
    contact.should be_a(Ppl::Entity::Contact)
  end

end

