
describe Ppl::Command::Shell do

  before(:each) do
    @command = Ppl::Command::Shell.new
    @input   = Ppl::Application::Input.new
    @output  = double(Ppl::Application::Output)
  end

  describe "#name" do
    it "should be 'shell'" do
      @command.name.should eq "shell"
    end
  end

  describe "#execute" do
    it "should read a line of input from stdin" do
      Readline.should_receive(:readline)
      @command.stub(:terminate_gracefully)
      @command.execute(@input, @output).should eq true
    end
  end

  describe "#execute" do

    before(:each) do
      @input.stdin = double(IO)
      @input.stdin.stub(:tty?) { true }
    end

    it "should not show a prompt if stdin isn't a tty" do
      @input.stdin.stub(:tty?) { false }
      Readline.should_receive(:readline).with("", true)
      @command.execute(@input, @output)
    end

    it "should show a prompt if stdin is a tty" do
      @input.stdin.stub(:tty?) { true }
      Readline.should_receive(:readline).with("ppl> ", true)
      @command.stub(:terminate_gracefully)
      @command.execute(@input, @output)
    end

    it "should make a system call with the input from stdin" do
      Readline.should_receive(:readline).and_return("email fred")
      Readline.should_receive(:readline).and_return(false)
      Kernel.should_receive(:system) do |command|
        command.should include "email fred"
      end
      @command.stub(:terminate_gracefully)
      @command.execute(@input, @output).should eq true
    end

    it "should exit on ctrl+c" do
      Readline.should_receive(:readline).and_raise(Interrupt)
      @command.stub(:terminate_gracefully)
      @command.execute(@input, @output).should eq false
    end

    it "should print a final newline on EOF so the user's prompt looks nice" do
      @input.stdin.stub(:tty?) { true }
      @output.should_receive(:line).with("")
      Readline.should_receive(:readline).and_return(false)
      @command.execute(@input, @output)
    end

    it "should print a final newline on error so the user's prompt looks nice" do
      @input.stdin.stub(:tty?) { true }
      @output.should_receive(:line).with("")
      @command.stub(:shell).and_raise(Interrupt)
      @command.execute(@input, @output)
    end

    it "should not print a final newline on EOF if stdin isn't a tty" do
      @input.stdin.stub(:tty?) { false }
      @output.should_not_receive(:line).with("")
      Readline.should_receive(:readline).and_return(false)
      @command.execute(@input, @output)
    end

  end

end

