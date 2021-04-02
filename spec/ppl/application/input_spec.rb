describe Ppl::Application::Input do

  before(:each) do
    @input = Ppl::Application::Input.new
  end

  describe "#arguments" do
    it "should be an array" do
      @input.arguments.should be_an(Array)
    end
  end

  describe "#options" do
    it "should be a hash" do
      @input.options.should be_a(Hash)
    end
  end

end

