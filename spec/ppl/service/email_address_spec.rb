
describe Ppl::Service::EmailAddress do

  before(:each) do
    @service = Ppl::Service::EmailAddress.new
    @contact = Ppl::Entity::Contact.new
    @storage = double(Ppl::Adapter::Storage)
    @storage.stub(:save_contact)
    @service.storage = @storage
    @contact.email_addresses << Ppl::Entity::EmailAddress.new("one@example.org")
  end

  describe "#add" do

    it "should add the email address to the contact" do
      @storage.stub(:save_contact) do |contact|
        contact.email_addresses[1].address.should eq "two@example.org"
      end
      @service.add(@contact, "two@example.org")
    end

    it "should store the contact" do
      @storage.should_receive(:save_contact).with(@contact)
      @service.add(@contact, "")
    end

  end

  describe "#update" do
    it "should store the updated contact" do
      @storage.should_receive(:save_contact).with(@contact)
      @service.update(@contact, "", {})
    end
  end

  describe "#remove" do

    it "should remove the email address from the contact" do
      @storage.stub(:save_contact) do |contact|
        contact.email_addresses.length.should eq 0
      end
      @service.remove(@contact, "one@example.org")
    end

    it "should store the contact" do
      @storage.should_receive(:save_contact).with(@contact)
      @service.remove(@contact, "")
    end

  end

end

