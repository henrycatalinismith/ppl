describe Ppl::Format::Contact::Nicknames do

  before(:each) do
    @format  = Ppl::Format::Contact::Nicknames.new
    @contact = Ppl::Entity::Contact.new
    @color   = double(Ppl::Adapter::Color)
    @format.color_adapter = @color
  end

  describe "#process" do

    it "should return an empty string if the contact lacks a nickname" do
      expect(@format.process(Ppl::Entity::Contact.new)).to eq ""
    end

    it "should return the contact's nickname if one is set" do
      @contact.nicknames.push("Dopey")
      expect(@format.process(@contact)).to eq "Dopey"
    end

    it "should colorize the string if configured to do so" do
      @format.colors = { "nicknames" => "blue" }
      expect(@color).to receive(:colorize).and_return("nicknames in blue")
      expect(@format.process(@contact)).to eq "nicknames in blue"
    end

  end

end

