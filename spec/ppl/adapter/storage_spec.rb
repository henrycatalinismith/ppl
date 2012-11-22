
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

  describe "#require_contact" do

    it "should raise Ppl::Error::ContactNotFound if load fails" do
      @storage.stub(:load_contact) do |id| end
      expect{@storage.require_contact("joe")}.to raise_error(Ppl::Error::ContactNotFound)
    end

    it "should return the loaded contact" do
      @storage.stub(:load_contact) do |id| Object.new end
      @storage.require_contact("joe").should be_an(Object)
    end
  end

end

