
describe Ppl::Format::Contact::EmailAddress do

  before(:each) do
    @format  = Ppl::Format::Contact::EmailAddress.new
    @contact = Ppl::Entity::Contact.new
  end

  describe "#process" do

    it "should return an empty string if the contact lacks an email address" do
      @format.process(Ppl::Entity::Contact.new).should eq ""
    end

    it "should return the contact's email address if it is set" do
      @contact.email_address = "jdoe@example.org"
      @format.process(@contact).should eq "jdoe@example.org"
    end

  end

end

