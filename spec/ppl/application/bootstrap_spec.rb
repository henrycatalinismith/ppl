
describe Ppl::Application::Bootstrap do

  before(:each) do
    @bootstrap = Ppl::Application::Bootstrap.new
  end

  describe "#input" do
    it "should return an instanceof Ppl::Application::Input" do
      @bootstrap.input.should be_a(Ppl::Application::Input)
    end
    it "should populate the object with the given arguments" do
      arguments = ["foo", "bar"]
      @bootstrap.input(arguments).arguments.should be(arguments)
    end
  end

end

