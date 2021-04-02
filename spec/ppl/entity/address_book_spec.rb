describe Ppl::Entity::AddressBook do

  before(:each) do
    @address_book = Ppl::Entity::AddressBook.new
  end

  describe "#contacts" do
    it "should be an array" do
      expect(@address_book.contacts).to be_an(Array)
    end
  end

end

