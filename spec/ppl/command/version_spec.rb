
describe Ppl::Command::Version do

  before(:each) do
    @command = Ppl::Command::Version.new
    @input   = Ppl::Application::Input.new
    @output  = double(Ppl::Application::Output)
  end

  describe "#name" do
    it "should be 'version'" do
      @command.name.should eq "version"
    end
  end

  describe "#execute" do
    it "should show the version number" do
      @output.should_receive(:line) do |line|
        line.should include Ppl::Version
      end
      @command.execute(@input, @output).should eq true
    end
  end

end

