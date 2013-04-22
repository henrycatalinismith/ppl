
describe Ppl::Service::PhoneNumber do

  before(:each) do
    @service = Ppl::Service::PhoneNumber.new
    @contact = Ppl::Entity::Contact.new
    @storage = double(Ppl::Adapter::Storage)
    @storage.stub(:save_contact)
    @service.storage = @storage
    @contact.phone_numbers << Ppl::Entity::PhoneNumber.new("01234567890")
  end

  describe "#add" do

    it "should add the phone number to the contact" do
      @service.add(@contact, "10987654321")
      @contact.phone_numbers[1].number.should eq "10987654321"
    end

    it "should store the contact" do
      @storage.should_receive(:save_contact).with(@contact)
      @service.add(@contact, "")
    end

  end

  describe "#remove" do

    it "should remove the phone number from the contact" do
      @service.remove(@contact, "01234567890")
      @contact.phone_numbers.length.should eq 0
    end

    it "should store the contact" do
      @storage.should_receive(:save_contact).with(@contact)
      @service.remove(@contact, "")
    end

  end

end

