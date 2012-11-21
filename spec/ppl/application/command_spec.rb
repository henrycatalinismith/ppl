
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

end

