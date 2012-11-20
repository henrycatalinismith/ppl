
describe Ppl::Adapter::Vcard, "#encode" do

  describe "#encode" do
    before(:each) do
      @adapter = Ppl::Adapter::Vcard.new
    end
    it "should raise not implemented error" do
      expect{@adapter.encode(nil)}.to raise_error(NotImplementedError)
    end
  end


  describe "#decode" do
    before(:each) do
      @adapter = Ppl::Adapter::Vcard.new
    end
    it "should raise not implemented error" do
      expect{@adapter.decode(nil)}.to raise_error(NotImplementedError)
    end
  end

end

