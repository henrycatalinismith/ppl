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
      expect(@config.address_book_path).to eq Dir.pwd
    end
    it "should be configurable by the user's config file" do
      allow(@config).to receive(:user_configuration) do
        {"address book" => {"path" => "/contacts"}}
      end
      expect(@config.address_book_path).to eq "/contacts"
    end
  end

  describe "#aliases" do
    it "should return a hash" do
      expect(@config.aliases).to be_a(Hash)
    end
  end

  describe "#color_enabled" do

    it "should return true if color is explicitly enabled" do
      allow(@config).to receive(:user_configuration).and_return({
        "color" => {
          "cmd" => "true",
        },
      })
      expect(@config.color_enabled("cmd")).to eq true
    end

    it "should return false if color is not explicitly enabled" do
      expect(@config.color_enabled("cmd")).to eq false
    end

    it "should return false if color is explicitly disabled" do
      allow(@config).to receive(:user_configuration).and_return({
        "color" => {
          "cmd" => "false",
        },
      })
      expect(@config.color_enabled("cmd")).to eq false
    end

  end

  describe "#command_colors" do

    before(:each) do
      allow(@config).to receive(:color_enabled).and_return(true)
      allow(@config).to receive(:user_configuration).and_return({
        "color \"ls\"" => {
          "id" => "blue",
        },
      })
    end

    it "should return the colors configured for the given command" do
      expect(@config.command_colors("ls")).to eq({
        "id" => "blue",
      })
    end

    it "should return an empty hash if colors aren't enabled for the command" do
      allow(@config).to receive(:color_enabled).and_return(false)
      expect(@config.command_colors("ls")).to eq({})
    end

    it "should return nil if no colors are configured for the given command" do
      allow(@config).to receive(:user_configuration).and_return({})
      expect(@config.command_colors("show")).to eq(nil)
    end

  end

end

