
describe Ppl::Command, "#execute" do
  before(:each) do
    @command = Ppl::Command.new
  end
  it "should raise not implemented error" do
    expect{@command.execute}.to raise_error(NotImplementedError)
  end
end

