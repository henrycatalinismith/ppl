describe Ppl::Format::Name::FullOnly do

  before(:each) do
    @format = Ppl::Format::Name::FullOnly.new
    @name   = Ppl::Entity::Name.new
    @color  = double(Ppl::Adapter::Color)
    @format.color_adapter = @color
  end

  describe "#process" do

    it "should return an empty string if the contact lacks a name" do
      expect(@format.process(@name)).to eq ""
    end

    it "should return just the full name" do
      @name.full = "John Doe"
      expect(@format.process(@name)).to eq "John Doe"
    end

    it "should colorize the string if configured to do so" do
      @format.colors = { "name" => "blue" }
      expect(@color).to receive(:colorize).and_return("name in blue")
      expect(@format.process(@name)).to eq "name in blue"
    end

  end

end

