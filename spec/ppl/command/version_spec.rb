describe Ppl::Command::Version do

  before(:each) do
    @command = Ppl::Command::Version.new
    @input   = Ppl::Application::Input.new
    @output  = double(Ppl::Application::Output)
  end

  describe "#name" do
    it "should be 'version'" do
      expect(@command.name).to eq "version"
    end
  end

  describe "#execute" do
    it "should show the version number" do
      expect(@output).to receive(:line) do |line|
        expect(line).to include Ppl::Version
      end
      expect(@command.execute(@input, @output)).to eq true
    end
  end

end

