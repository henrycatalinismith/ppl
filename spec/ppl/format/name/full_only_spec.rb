
describe Ppl::Format::Name::FullOnly do

  before(:each) do
    @format = Ppl::Format::Name::FullOnly.new
    @name   = Ppl::Entity::Name.new
    @color  = double(Ppl::Adapter::Color)
    @format.color_adapter = @color
  end

  describe "#process" do

    it "should return an empty string if the contact lacks a name" do
      @format.process(@name).should eq ""
    end

    it "should return just the full name" do
      @name.full = "John Doe"
      @format.process(@name).should eq "John Doe"
    end

    it "should colorize the string if configured to do so" do
      @format.colors = { "name" => "blue" }
      @color.should_receive(:colorize).and_return("name in blue")
      @format.process(@name).should eq "name in blue"
    end

  end

end

