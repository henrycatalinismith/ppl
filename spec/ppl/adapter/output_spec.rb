
describe Ppl::Application::Output, "#initialize" do

  it "should accept stdout" do
    stdout = Object.new
    @output = Ppl::Application::Output.new(stdout, nil)
    @output.stdout.should be stdout
  end

  it "should accept stderr" do
    stderr = Object.new
    @output = Ppl::Application::Output.new(nil, stderr)
    @output.stderr.should be stderr
  end

end

describe Ppl::Application::Output do

  before(:each) do
    @stderr = double(IO)
    @stdout = double(IO)
    @output = Ppl::Application::Output.new(@stdout, @stderr)
  end

  describe "#error" do
    it "should delegate to stderr's puts method" do
      string = "COMPUTER OVER. VIRUS = VERY YES"
      @stderr.should_receive(:puts).with(string)
      @output.error(string)
    end
  end

  describe "#line" do
    it "should delegate to stdout's puts method" do
      string = "The quick brown fox"
      @stdout.should_receive(:puts).with(string)
      @output.line(string)
    end

    it "should not send carriage returns to stdout" do
      string = "The quick brown fox"
      @stdout.should_receive(:puts).with("The quick brown fox")
      @output.line(string)
    end

    it "should not send carriage returns to stderr" do
      string = "The quick brown fox"
      @stderr.should_receive(:puts).with("The quick brown fox")
      @output.error(string)
    end

    it "should not sanitise output if nil" do
      string = nil
      @stdout.should_receive(:puts).with(nil)
      @output.line(string)
    end
  end

end

