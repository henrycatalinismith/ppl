
describe Ppl::Application::Configuration do

  before(:each) do
    FakeFS.activate!
    @config = Ppl::Application::Configuration.new
  end

  after(:each) do
    FakeFS.deactivate!
  end

  describe "#address_book_path" do
    it "should default to the current working directory" do
      @config.address_book_path.should eq Dir.pwd
    end
    it "should be configurable by the user's config file" do
      @config.stub(:user_configuration) do
        {"address book" => {"path" => "/contacts"}}
      end
      @config.address_book_path.should eq "/contacts"
    end
  end

end

