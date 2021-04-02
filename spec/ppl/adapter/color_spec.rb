describe Ppl::Adapter::Color do

  before(:each) do
    @adapter = Ppl::Adapter::Color.new
  end

  describe "#colorize" do
    it "should raise not implemented error" do
      expect{@adapter.colorize(nil, nil)}.to raise_error(NotImplementedError)
    end
  end

end

