
describe Ppl::Format::Contact::EmailAddresses do

  before(:each) do
    @format  = Ppl::Format::Contact::EmailAddresses.new
    @contact = Ppl::Entity::Contact.new
    @color   = double(Ppl::Adapter::Color)
    @format.color_adapter = @color
  end

  describe "#process" do

    it "should return an empty string if the contact lacks an email address" do
      @format.process(Ppl::Entity::Contact.new).should eq ""
    end

    it "should return the contact's email address if it is set" do
      @contact.email_addresses.push "jdoe@example.org"
      @format.process(@contact).should eq "jdoe@example.org"
    end

    it "should colorize the string if configured to do so" do
      @format.colors = { "email_addresses" => "blue" }
      @color.should_receive(:colorize).and_return("email addresses in blue")
      @format.process(@contact).should eq "email addresses in blue"
    end

  end

end

