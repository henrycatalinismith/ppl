describe Ppl::Command::Init do

  before(:each) do
    @command = Ppl::Command::Init.new
    @input   = Ppl::Application::Input.new
    @output  = Ppl::Application::Output.new(nil, nil)
  end

  describe "#name" do
    it "should be 'init'" do
      expect(@command.name).to eq "init"
    end
  end

  describe "#execute" do

    it "should pass the given path through to the storage adapter" do
      allow(Ppl::Adapter::Storage::Git).to receive(:create_address_book) do |path|
        expect(path).to eq "/contacts"
      end
      @input.arguments.push "/contacts"
      @command.execute(@input, @output)
    end

    it "should pass the cwd to the storage adapter if no path is given" do
      FakeFS.activate!
      Dir.mkdir "/current"
      Dir.chdir "/current"
      allow(Ppl::Adapter::Storage::Git).to receive(:create_address_book) do |path|
        expect(path).to eq "/current"
      end
      @command.execute(@input, @output)
      FakeFS.deactivate!
    end

  end

end

