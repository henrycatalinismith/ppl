
describe Ppl::Format::Contact::Urls do

  before(:each) do
    @format  = Ppl::Format::Contact::Urls.new
    @contact = Ppl::Entity::Contact.new
  end

  describe "#process" do

    it "should return an empty string if the contact lacks a URL" do
      @format.process(Ppl::Entity::Contact.new).should eq ""
    end

    it "should return the contact's URL if one is set" do
      @contact.urls.push "http://example.org/~jdoe"
      @format.process(@contact).should eq "http://example.org/~jdoe"
    end

  end

end

