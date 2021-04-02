describe Ppl::Application::Input do

  before(:each) do
    @input = Ppl::Application::Input.new
  end

  describe "#arguments" do
    it "should be an array" do
      expect(@input.arguments).to be_an(Array)
    end
  end

  describe "#options" do
    it "should be a hash" do
      expect(@input.options).to be_a(Hash)
    end
  end

end

