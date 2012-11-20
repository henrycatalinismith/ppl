
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

