
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

  describe "#aliases" do
    it "should return a hash" do
      @config.aliases.should be_a(Hash)
    end
  end

  describe "#color_enabled" do

    it "should return true if color is explicitly enabled" do
      @config.stub(:user_configuration).and_return({
        "color" => {
          "cmd" => "true",
        },
      })
      @config.color_enabled("cmd").should eq true
    end

    it "should return false if color is not explicitly enabled" do
      @config.color_enabled("cmd").should eq false
    end

    it "should return false if color is explicitly disabled" do
      @config.stub(:user_configuration).and_return({
        "color" => {
          "cmd" => "false",
        },
      })
      @config.color_enabled("cmd").should eq false
    end

  end

  describe "#command_colors" do

    it "should return the colors configured for the given command" do
      @config.stub(:user_configuration).and_return({
        "color \"ls\"" => {
          "id" => "blue",
        },
      })
      @config.command_colors("ls").should eq({
        "id" => "blue",
      })
    end

    it "should return nil if no colors are configured for the given command" do
      @config.stub(:user_configuration).and_return({})
      @config.command_colors("ls").should eq(nil)
    end

  end

end

