describe Ppl::Format::Contact::Urls do

  before(:each) do
    @format  = Ppl::Format::Contact::Urls.new
    @contact = Ppl::Entity::Contact.new
    @color   = double(Ppl::Adapter::Color)
    @format.color_adapter = @color
  end

  describe "#process" do

    it "should return an empty string if the contact lacks a URL" do
      expect(@format.process(Ppl::Entity::Contact.new)).to eq ""
    end

    it "should return the contact's URL if one is set" do
      @contact.urls.push "http://example.org/~jdoe"
      expect(@format.process(@contact)).to eq "http://example.org/~jdoe"
    end

    it "should colorize the string if configured to do so" do
      @format.colors = { "urls" => "blue" }
      expect(@color).to receive(:colorize).and_return("urls in blue")
      expect(@format.process(@contact)).to eq "urls in blue"
    end

  end

end

