describe Ppl::Adapter::Color::Colored do

  before(:each) do
    @adapter = Ppl::Adapter::Color::Colored.new
  end

  describe "#colorize" do

    it "should colorize the string using the monkeypatched String method" do
      string = "example"
      expect(string).to receive(:red).and_return("red example")
      expect(@adapter.colorize(string, "red")).to eq "red example"
    end

    it "should only attempt to colorize the string if the color exists" do
      string = "example"
      expect(@adapter.colorize(string, "neon")).to eq "example"
    end

  end

end

