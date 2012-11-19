
describe Ppl::Application::CommandSelector, "#aliases" do
  before(:each) do
    @selector = Ppl::Application::CommandSelector.new
  end
  it "should be an array" do
    @selector.aliases.should be_an(Array)
  end
end

describe Ppl::Application::CommandSelector, "#commands" do
  before(:each) do
    @selector = Ppl::Application::CommandSelector.new
  end
  it "should be an array" do
    @selector.commands.should be_an(Array)
  end
end

