describe Ppl::Command::Shell do

  before(:each) do
    @command = Ppl::Command::Shell.new
    @input   = Ppl::Application::Input.new
    @output  = double(Ppl::Application::Output)
  end

  describe "#name" do
    it "should be 'shell'" do
      expect(@command.name).to eq "shell"
    end
  end

  describe "#execute" do
    it "should read a line of input from stdin" do
      expect(Readline).to receive(:readline)
      allow(@command).to receive(:welcome_user)
      allow(@command).to receive(:terminate_gracefully)
      expect(@command.execute(@input, @output)).to eq true
    end
  end

  describe "#execute" do

    before(:each) do
      @input.stdin = double(IO)
      allow(@input.stdin).to receive(:tty?) { true }
    end

    it "should not show a prompt if stdin isn't a tty" do
      allow(@input.stdin).to receive(:tty?) { false }
      expect(Readline).to receive(:readline).with("", true)
      allow(@command).to receive(:welcome_user)
      @command.execute(@input, @output)
    end

    it "should show a prompt if stdin is a tty" do
      allow(@input.stdin).to receive(:tty?) { true }
      expect(Readline).to receive(:readline).with("ppl> ", true)
      allow(@command).to receive(:welcome_user)
      allow(@command).to receive(:terminate_gracefully)
      @command.execute(@input, @output)
    end

    it "should make a system call with the input from stdin" do
      expect(Readline).to receive(:readline).and_return("email fred")
      expect(Readline).to receive(:readline).and_return(false)
      expect(Kernel).to receive(:system) do |command|
        expect(command).to include "email fred"
      end
      allow(@command).to receive(:welcome_user)
      allow(@command).to receive(:terminate_gracefully)
      expect(@command.execute(@input, @output)).to eq true
    end

    it "should exit on ctrl+c" do
      expect(Readline).to receive(:readline).and_raise(Interrupt)
      allow(@command).to receive(:welcome_user)
      allow(@command).to receive(:terminate_gracefully)
      expect(@command.execute(@input, @output)).to eq false
    end

    it "should print a final newline on EOF so the user's prompt looks nice" do
      allow(@input.stdin).to receive(:tty?) { true }
      expect(@output).to receive(:line).with("")
      expect(Readline).to receive(:readline).and_return(false)
      allow(@command).to receive(:welcome_user)
      @command.execute(@input, @output)
    end

    it "should print a final newline on error so the user's prompt looks nice" do
      allow(@input.stdin).to receive(:tty?) { true }
      expect(@output).to receive(:line).with("")
      allow(@command).to receive(:shell).and_raise(Interrupt)
      @command.execute(@input, @output)
    end

    it "should not print a final newline on EOF if stdin isn't a tty" do
      allow(@input.stdin).to receive(:tty?) { false }
      expect(@output).not_to receive(:line).with("")
      expect(Readline).to receive(:readline).and_return(false)
      allow(@command).to receive(:welcome_user)
      @command.execute(@input, @output)
    end

    it "should print a welcome message on the tty" do
      allow(@input.stdin).to receive(:tty?) { true }
      expect(@output).to receive(:line) do |line|
        expect(line).to include "ppl"
        expect(line).to include Ppl::VERSION
      end
      expect(Readline).to receive(:readline).and_return(false)
      allow(@command).to receive(:terminate_gracefully)
      @command.execute(@input, @output)
    end

  end

end

