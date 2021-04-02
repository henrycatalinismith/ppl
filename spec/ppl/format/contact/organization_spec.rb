describe Ppl::Format::Contact::Organization do

  before(:each) do
    @format  = Ppl::Format::Contact::Organization.new
    @contact = Ppl::Entity::Contact.new
    @color   = double(Ppl::Adapter::Color)
    @format.color_adapter = @color
  end

  describe "#process" do

    it "should return an empty string if the contact lacks an organization" do
      expect(@format.process(Ppl::Entity::Contact.new)).to eq ""
    end

    it "should return the contact's organization if it is set" do
      @contact.organizations.push("Example Ltd")
      expect(@format.process(@contact)).to eq "Example Ltd"
    end

    it "should colorize the string if configured to do so" do
      @format.colors = { "organizations" => "blue" }
      expect(@color).to receive(:colorize).and_return("organizations in blue")
      expect(@format.process(@contact)).to eq "organizations in blue"
    end

  end

end

