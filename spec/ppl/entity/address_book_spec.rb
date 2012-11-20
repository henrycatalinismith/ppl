
describe Ppl::Entity::AddressBook do

  before(:each) do
    @address_book = Ppl::Entity::AddressBook.new
  end

  describe "#add_contact" do
    it "should accept a contact" do
      @address_book.add_contact(double(Ppl::Entity::Contact))
      @address_book.count.should be 1
    end
  end

  describe "#each" do
    it "should yield contacts" do
      contact = double(Ppl::Entity::Contact)
      @address_book.add_contact(contact)
      @address_book.each do |c|
        c.should be contact
      end
    end
  end

end

