
describe Ppl::Format::Contact::Name do

  before(:each) do
    @format  = Ppl::Format::Contact::Name.new
    @contact = Ppl::Entity::Contact.new
    @color   = double(Ppl::Adapter::Color)
    @format.color_adapter = @color
  end

  describe "#process" do

    it "should return an empty string if the contact lacks a name" do
      @format.process(Ppl::Entity::Contact.new).should eq ""
    end

    it "should return the contact's name if it is set" do
      @contact.name = "John Doe"
      @format.process(@contact).should eq "John Doe"
    end

    it "should colorize the string if configured to do so" do
      @format.colors = { "name" => "blue" }
      @color.should_receive(:colorize).and_return("name in blue")
      @format.process(@contact).should eq "name in blue"
    end

  end

end

