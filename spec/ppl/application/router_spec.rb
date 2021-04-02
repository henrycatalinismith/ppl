describe Ppl::Application::Router do

  before(:each) do
    @suite  = Ppl::Application::CommandSuite.new
    @router = Ppl::Application::Router.new(@suite)

    @external = double(Ppl::Command::External)
    @router.external_command = @external

    @cmd_one = Ppl::Application::Command.new
    @cmd_one.name = "one"

    @cmd_two = Ppl::Application::Command.new
    @cmd_two.name = "two"

    @suite.add_command(@cmd_one)
    @suite.add_command(@cmd_two)
  end

  describe "#default=" do
    it "should accept the name of the default command" do
      @router.default = "one"
      @router.default.should eq "one"
    end
  end

  describe "#route" do

    it "should return the command whose name matches the given argument" do
      @router.route("two").should be @cmd_two
    end

    it "should return nil if no matching command can be found" do
      @router.route("three").should be nil
    end

    it "should fall back to the default command if the given one isn't found" do
      @router.default = "one"
      @router.route("three").should be @cmd_one
    end

    it "should apply the aliases if the argument doesn't match a command" do
      @router.aliases = {"t" => "two"}
      @router.route("t").should be @cmd_two
    end

    it "should return a Ppl::Command::External if the input matches a bang alias" do
      @external.should_receive(:name=).with("t")
      @external.should_receive(:command=).with("two")
      @router.aliases = {"t" => "!two"}
      @router.route("t").should be @external
    end

  end

end

