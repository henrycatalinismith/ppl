
describe Ppl::Application::Command, "#execute" do

  before(:each) do
    @command = Ppl::Application::Command.new
  end

  it "should raise not implemented error" do
    expect{@command.execute(nil, nil)}.to raise_error(NotImplementedError)
  end

  it "should accept a storage adapter" do
    storage = double(Ppl::Adapter::Storage)
    @command.storage = storage
    @command.storage.should be storage
  end

  it "should allow the name to be set as an instance variable" do
    @command.name = "testing"
    @command.name.should eq "testing"
  end

  it "should allow the description to be set as an instance variable" do
    @command.description = "testing"
    @command.description.should eq "testing"
  end

  it "should allow the name to be set as a class variable" do
    class TestCommand123 < Ppl::Application::Command
      name "new_for_test"
    end
    command = TestCommand123.new
    command.name.should eq "new_for_test"
  end

  it "should allow the description to be set as a class variable" do
    class TestCommand123 < Ppl::Application::Command
      description "desc_for_test"
    end
    command = TestCommand123.new
    command.description.should eq "desc_for_test"
  end

end

