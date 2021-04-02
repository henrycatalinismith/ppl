describe Ppl::Format::Contact::Organization do

  before(:each) do
    @format  = Ppl::Format::Contact::Organization.new
    @contact = Ppl::Entity::Contact.new
    @color   = double(Ppl::Adapter::Color)
    @format.color_adapter = @color
  end

  describe "#process" do

    it "should return an empty string if the contact lacks an organization" do
      @format.process(Ppl::Entity::Contact.new).should eq ""
    end

    it "should return the contact's organization if it is set" do
      @contact.organizations.push("Example Ltd")
      @format.process(@contact).should eq "Example Ltd"
    end

    it "should colorize the string if configured to do so" do
      @format.colors = { "organizations" => "blue" }
      @color.should_receive(:colorize).and_return("organizations in blue")
      @format.process(@contact).should eq "organizations in blue"
    end

  end

end

