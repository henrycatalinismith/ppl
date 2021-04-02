describe Ppl::Application::CommandSuite do

  before(:each) do
    @command_suite = Ppl::Application::CommandSuite.new

    @foo_command      = Ppl::Application::Command.new
    @foo_command.name = "foo"

    @bar_command      = Ppl::Application::Command.new
    @bar_command.name = "bar"

    @command_suite.add_command(@foo_command)
    @command_suite.add_command(@bar_command)
  end

  describe "#add_command" do
    it "should accept a command" do
      @command_suite.add_command(Ppl::Application::Command.new)
      expect(@command_suite.count).to be 3
    end
  end

  describe "#find_command" do
    it "should find a command matching the given name" do
      expect(@command_suite.find_command("foo")).to be @foo_command
    end
    it "should return nil if no commands match the given name" do
      expect(@command_suite.find_command("baz")).to be nil
    end
  end

  describe "#each" do
    it "should yield commands" do
      expect(@command_suite)
        .to receive(:each)
        .and_yield(@foo_command)
        .and_yield(@bar_command)
      @command_suite.each do |c| end
    end
  end

  describe "#sort_by_name" do
    it "should sort the commands alphabetically by name" do
      @command_suite.sort_by_name
      expect(@command_suite[0].name).to eq "bar"
      expect(@command_suite[1].name).to eq "foo"
    end
  end

end

