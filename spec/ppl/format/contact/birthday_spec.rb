
describe Ppl::Format::Contact::Birthday do

  before(:each) do
    @format  = Ppl::Format::Contact::Birthday.new
    @contact = Ppl::Entity::Contact.new
  end

  describe "#process" do

    it "should return an empty string if the contact lacks a birthday" do
      @format.process(Ppl::Entity::Contact.new).should eq ""
    end

    it "should return the contact's birthday if it is set" do
      @contact.birthday = Date.parse("1970-01-01")
      @format.process(@contact).should eq "1970-01-01"
    end

  end

end

