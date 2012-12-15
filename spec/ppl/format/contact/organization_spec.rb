
describe Ppl::Format::Contact::Organization do

  before(:each) do
    @format  = Ppl::Format::Contact::Organization.new
    @contact = Ppl::Entity::Contact.new
  end

  describe "#process" do

    it "should return an empty string if the contact lacks an organization" do
      @format.process(Ppl::Entity::Contact.new).should eq ""
    end

    it "should return the contact's organization if it is set" do
      @contact.organization = "Example Ltd"
      @format.process(@contact).should eq "Example Ltd"
    end

  end

end

