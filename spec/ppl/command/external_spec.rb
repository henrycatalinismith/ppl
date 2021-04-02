describe Ppl::Command::External do

  before(:each) do
    @command = Ppl::Command::External.new("remote", "git remote", "Execute 'git remote' in the address book directory")
    @input   = Ppl::Application::Input.new
    @output  = double(Ppl::Application::Output)
    @storage = double(Ppl::Adapter::Storage)

    allow(@storage).to receive(:path).and_return("/contacts")
    @command.storage = @storage
  end

  describe "#execute" do

    it "should chdir to the location of the address book on disk" do
      expect(Dir).to receive(:chdir).with("/contacts")
      allow(Kernel).to receive(:exec)
      @command.execute(@input, @output)
    end

    it "should run the specified command" do
      allow(Dir).to receive(:chdir)
      expect(Kernel).to receive(:exec).with("git remote")
      @command.execute(@input, @output)
    end

    it "should pass arguments through to the command" do
      @input.arguments = ["--help"]
      allow(Dir).to receive(:chdir)
      expect(Kernel).to receive(:exec).with("git remote --help")
      @command.execute(@input, @output)
    end

  end

end

