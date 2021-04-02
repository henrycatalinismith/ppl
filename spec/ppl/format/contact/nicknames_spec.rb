describe Ppl::Format::Contact::Nicknames do

  before(:each) do
    @format  = Ppl::Format::Contact::Nicknames.new
    @contact = Ppl::Entity::Contact.new
    @color   = double(Ppl::Adapter::Color)
    @format.color_adapter = @color
  end

  describe "#process" do

    it "should return an empty string if the contact lacks a nickname" do
      @format.process(Ppl::Entity::Contact.new).should eq ""
    end

    it "should return the contact's nickname if one is set" do
      @contact.nicknames.push("Dopey")
      @format.process(@contact).should eq "Dopey"
    end

    it "should colorize the string if configured to do so" do
      @format.colors = { "nicknames" => "blue" }
      @color.should_receive(:colorize).and_return("nicknames in blue")
      @format.process(@contact).should eq "nicknames in blue"
    end

  end

end

