
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

describe Ppl::Application::CommandSelector, "#add_alias" do
  before(:each) do
    @selector = Ppl::Application::CommandSelector.new
  end
  it "should add an alias" do
    @selector.add_alias(Ppl::Entity::Alias.new("l", "ls"))
    @selector.aliases.length.should be 1
  end
end

describe Ppl::Application::CommandSelector, "#add_command" do
  before(:each) do
    @selector = Ppl::Application::CommandSelector.new
  end
  it "should add a command" do
    @selector.add_command(Ppl::Command.new)
    @selector.commands.length.should be 1
  end
end

