
describe Ppl::Format::Contact::PhoneNumber do

  before(:each) do
    @format  = Ppl::Format::Contact::PhoneNumber.new
    @contact = Ppl::Entity::Contact.new
    @color   = double(Ppl::Adapter::Color)
    @format.color_adapter = @color
  end

  describe "#process" do

    it "should return an empty string if the contact lacks a phone number" do
      @format.process(Ppl::Entity::Contact.new).should eq ""
    end

    it "should return the contact's phone number if it is set" do
      @contact.phone_numbers.push("0123456789")
      @format.process(@contact).should eq "0123456789"
    end

    it "should colorize the string if configured to do so" do
      @format.colors = { "phone_numbers" => "blue" }
      @color.should_receive(:colorize).and_return("phone numbers in blue")
      @format.process(@contact).should eq "phone numbers in blue"
    end

  end

end

