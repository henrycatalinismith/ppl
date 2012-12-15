
describe Ppl::Format::Contact::Name do

  before(:each) do
    @format  = Ppl::Format::Contact::Name.new
    @contact = Ppl::Entity::Contact.new
  end

  describe "#process" do

    it "should return an empty string if the contact lacks a name" do
      @format.process(Ppl::Entity::Contact.new).should eq ""
    end

    it "should return the contact's name if it is set" do
      @contact.name = "John Doe"
      @format.process(@contact).should eq "John Doe"
    end

  end

end

