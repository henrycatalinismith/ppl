
describe Ppl::Command::Execute do

  before(:each) do
    @command = Ppl::Command::Execute.new("remote", "git remote", "Execute 'git remote' in the address book directory")
    @input   = Ppl::Application::Input.new
    @output  = double(Ppl::Application::Output)
    @storage = double(Ppl::Adapter::Storage)

    @storage.stub(:path).and_return("/contacts")
    @command.storage = @storage
  end

  describe "#execute" do

    it "should chdir to the location of the address book on disk" do
      Dir.should_receive(:chdir).with("/contacts")
      Kernel.stub(:exec)
      @command.execute(@input, @output)
    end

    it "should run the specified command" do
      Dir.stub(:chdir)
      Kernel.should_receive(:exec).with("git remote")
      @command.execute(@input, @output)
    end

    it "should pass arguments through to the command" do
      @input.arguments = ["--help"]
      Dir.stub(:chdir)
      Kernel.should_receive(:exec).with("git remote --help")
      @command.execute(@input, @output)
    end

  end

end

