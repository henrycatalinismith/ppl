
describe Ppl::Entity::Contact, "#email_addresses" do

  before(:each) do
    @contact = Ppl::Entity::Contact.new
  end

  it "is an array" do
      @contact.email_addresses.should be_an(Array)
  end

end

describe Ppl::Entity::Contact, "#postal_addresses" do

  before(:each) do
    @contact = Ppl::Entity::Contact.new
  end

  it "is an array" do
      @contact.postal_addresses.should be_an(Array)
  end

end

describe Ppl::Entity::Contact, "#phone_numbers" do

  before(:each) do
    @contact = Ppl::Entity::Contact.new
  end

  it "is an array" do
      @contact.phone_numbers.should be_an(Array)
  end

end


