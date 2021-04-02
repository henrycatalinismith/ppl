describe Ppl::Adapter::Color::Colored do

  before(:each) do
    @adapter = Ppl::Adapter::Color::Colored.new
  end

  describe "#colorize" do

    it "should colorize the string using the monkeypatched String method" do
      string = "example"
      string.should_receive(:red).and_return("red example")
      @adapter.colorize(string, "red").should eq "red example"
    end

    it "should only attempt to colorize the string if the color exists" do
      string = "example"
      @adapter.colorize(string, "neon").should eq "example"
    end

  end

end

