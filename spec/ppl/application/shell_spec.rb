describe Ppl::Application::Shell do

  before(:each) do
    @shell  = Ppl::Application::Shell.new
    @input  = Ppl::Application::Input.new
    @output = double(Ppl::Application::Output)

    @router  = double(Ppl::Application::Router)
    @command = double(Ppl::Application::Command)

    @shell.router = @router
  end

  describe "#run" do

    it "should return false if the given command isn't found" do
      @input.arguments = ["foo"]
      expect(@router)
        .to receive(:route)
        .with("foo")
        .and_return(nil)
      expect(@shell.run(@input, @output)).to eq false
    end

    it "should execute the given command" do
      @input.arguments = ["foo"]
      expect(@router)
        .to receive(:route)
        .with("foo")
        .and_return(@command)

      expect(@command).to receive(:options)
      expect(@command)
        .to receive(:execute)
        .and_return(true)

      expect(@shell.run(@input, @output)).to eq true
    end

    it "should not pass the command name in the input to the command itself" do
      @input.arguments = ["mv", "foo", "bar"]
      expect(@router)
        .to receive(:route)
        .with("mv")
        .and_return(@command)

      expect(@command).to receive(:options)
      expect(@command).to receive(:execute) do |input, output|
        expect(input.arguments).to eq ["foo", "bar"]
      end
      @shell.run(@input, @output)
    end

    it "should return false if the command throws an exception" do
      expect(@command).to receive(:options)
      expect(@command)
        .to receive(:execute)
        .and_raise(StandardError)

      expect(@router)
        .to receive(:route)
        .and_return(@command)

      expect(@output).to receive(:error)

      @shell.run(@input, @output)
    end

    it "should not do any option parsing for Ppl::Command::External instances" do
      external = Ppl::Command::External.new("ls", "ls", "List directory contents")
      allow(external).to receive(:execute).and_return(true)
      expect(@shell).to receive(:select_command).and_return(external)
      expect(external).not_to receive(:options)
      @shell.run(@input, @output)
    end

    it "should send exception messages to stderr" do
      expect(@command).to receive(:options)
      expect(@command).to receive(:execute) { raise "Pool's Closed" }
      expect(@router).to receive(:route).and_return(@command)
      expect(@output).to receive(:error).with("ppl: Pool's Closed")
      @shell.run(@input, @output)
    end

    it "should handle ContactNotFound errors nicely" do
      allow(@command).to receive(:options)
      expect(@command).to receive(:execute) { raise Ppl::Error::ContactNotFound, "example" }
      expect(@router).to receive(:route).and_return(@command)
      expect(@output).to receive(:error).with("ppl: Contact 'example' not found")
      @shell.run(@input, @output)
    end

    it "should handle CompletionNotFound errors nicely" do
      allow(@command).to receive(:options)
      expect(@command).to receive(:execute) { raise Ppl::Error::CompletionNotFound, "example" }
      expect(@router).to receive(:route).and_return(@command)
      expect(@output).to receive(:error).with("ppl: No completion function available for 'example'")
      @shell.run(@input, @output)
    end

    it "should handle PostalAddressNotFound errors nicely" do
      allow(@command).to receive(:options)
      expect(@command).to receive(:execute) { raise Ppl::Error::PostalAddressNotFound, "example" }
      expect(@router).to receive(:route).and_return(@command)
      expect(@output).to receive(:error).with("ppl: Postal address 'example' not found")
      @shell.run(@input, @output)
    end

  end

end

