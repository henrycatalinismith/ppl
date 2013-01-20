
describe Ppl::Format::Contact::Nicknames do

  before(:each) do
    @format  = Ppl::Format::Contact::Nicknames.new
    @contact = Ppl::Entity::Contact.new
  end

  describe "#process" do

    it "should return an empty string if the contact lacks a nickname" do
      @format.process(Ppl::Entity::Contact.new).should eq ""
    end

    it "should return the contact's nickname if one is set" do
      @contact.nicknames.push("Dopey")
      @format.process(@contact).should eq "Dopey"
    end

  end

end

