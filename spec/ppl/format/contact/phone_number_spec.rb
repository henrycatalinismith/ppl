
describe Ppl::Format::Contact::PhoneNumber do

  before(:each) do
    @format  = Ppl::Format::Contact::PhoneNumber.new
    @contact = Ppl::Entity::Contact.new
  end

  describe "#process" do

    it "should return an empty string if the contact lacks a phone number" do
      @format.process(Ppl::Entity::Contact.new).should eq ""
    end

    it "should return the contact's phone number if it is set" do
      @contact.phone_number = "0123456789"
      @format.process(@contact).should eq "0123456789"
    end

  end

end

