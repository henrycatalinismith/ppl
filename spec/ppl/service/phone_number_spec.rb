describe Ppl::Service::PhoneNumber do

  before(:each) do
    @service = Ppl::Service::PhoneNumber.new
    @contact = Ppl::Entity::Contact.new
    @storage = double(Ppl::Adapter::Storage)
    allow(@storage).to receive(:save_contact)
    @service.storage = @storage
    @contact.phone_numbers << Ppl::Entity::PhoneNumber.new("01234567890")
  end

  describe "#add" do

    it "should add the phone number to the contact" do
      @service.add(@contact, "10987654321", {})
      expect(@contact.phone_numbers[1].number).to eq "10987654321"
    end

    it "should process the input options against the new contact" do
      @service.add(@contact, "10987654321", {:preferred => true})
      expect(@contact.phone_numbers[1].preferred).to eq true
    end

    it "should store the contact" do
      expect(@storage).to receive(:save_contact).with(@contact)
      @service.add(@contact, "", {})
    end

  end

  describe "#update" do
    
    it "should update the number's type" do
      @service.update(@contact, "01234567890", {:type => "cell"})
      expect(@contact.phone_numbers.first.type).to eq "cell"
    end

    it "should update the number's preferred status" do
      @contact.phone_numbers << Ppl::Entity::PhoneNumber.new("109876543210")
      @contact.phone_numbers[1].preferred = true
      @service.update(@contact, "01234567890", {:preferred => true})
      expect(@contact.phone_numbers[0].preferred).to eq true
      expect(@contact.phone_numbers[1].preferred).to eq false
    end

    it "should mark numbers as not preferred" do
      @contact.phone_numbers[0].preferred = true
      @service.update(@contact, "01234567890", {:preferred => false})
      expect(@contact.phone_numbers[0].preferred).to eq false
    end

    it "should store the contact" do
      expect(@storage).to receive(:save_contact).with(@contact)
      @service.update(@contact, "", {})
    end

  end

  describe "#remove" do

    it "should remove the phone number from the contact" do
      @service.remove(@contact, "01234567890")
      expect(@contact.phone_numbers.length).to eq 0
    end

    it "should store the contact" do
      expect(@storage).to receive(:save_contact).with(@contact)
      @service.remove(@contact, "")
    end

  end

end

