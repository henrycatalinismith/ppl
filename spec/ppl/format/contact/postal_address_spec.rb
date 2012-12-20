
describe Ppl::Format::Contact::PostalAddress do

  before(:each) do
    @format  = Ppl::Format::Contact::PostalAddress.new
    @contact = Ppl::Entity::Contact.new
  end

  describe "#process" do

    it "should return an empty string if the contact lacks a postal address" do
      @format.process(Ppl::Entity::Contact.new).should eq ""
    end

    it "should return the contact's postal address if it is set" do
      @contact.postal_address = "1 Test Road"
      @format.process(@contact).should eq "1 Test Road"
    end

  end

end

