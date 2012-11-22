
describe Ppl::Adapter::Storage do

  before(:each) do
    @storage = Ppl::Adapter::Storage.new
  end

  describe "#delete_contact" do
    it "should raise not implemented error" do
      expect{@storage.delete_contact(nil)}.to raise_error(NotImplementedError)
    end
  end

  describe "#load_address_book" do
    it "should raise not implemented error" do
      expect{@storage.load_address_book}.to raise_error(NotImplementedError)
    end
  end

  describe "#load_contact" do
    it "should raise not implemented error" do
      expect{@storage.load_contact(nil)}.to raise_error(NotImplementedError)
    end
  end

end

