
describe Ppl::Entity::Contact, "#email_addresses" do

  before(:each) do
    @contact = Ppl::Entity::Contact.new
  end

  it "is an array" do
      @contact.email_addresses.should be_a(Array)
  end

end

