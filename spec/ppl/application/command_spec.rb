
describe Ppl::Application::Command, "#execute" do

  before(:each) do
    @command = Ppl::Application::Command.new
  end

  it "should raise not implemented error" do
    expect{@command.execute(nil, nil)}.to raise_error(NotImplementedError)
  end

end

