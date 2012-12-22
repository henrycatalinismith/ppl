
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
    before(:each) do
      @output.should_receive(:line)
    end
    it "should read a line of input from stdin" do
      Readline.should_receive(:readline)
      @command.execute(@input, @output).should eq true
    end
  end

  describe "#execute" do
    before(:each) do
      @output.should_receive(:line)
    end

    it "should make a system call with the input from stdin" do
      Readline.should_receive(:readline).and_return("email fred")
      Readline.should_receive(:readline).and_return(false)
      Kernel.should_receive(:system) do |command|
        command.should include "email fred"
      end
      @command.execute(@input, @output).should eq true
    end

    it "should exit on ctrl+c" do
      Readline.should_receive(:readline).and_raise(Interrupt)
      @command.execute(@input, @output).should eq false
    end

  end

end

