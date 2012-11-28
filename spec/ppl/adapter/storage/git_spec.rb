
describe Ppl::Adapter::Storage::Git, "#initialize" do

  before(:each) do
    @disk    = double(Ppl::Adapter::Storage::Disk)
    @contact = double(Ppl::Entity::Contact)

    @contact.stub(:id).and_return("test")

    @git = Ppl::Adapter::Storage::Git.new(@disk)
  end

  describe "#initialize" do
    it "should accept a disk storage adapter" do
      @git.disk.should be @disk
    end
  end

  describe "#save_contact" do

    it "should save the contact to disk" do
      @disk.should_receive(:save_contact).with(@contact)
      @git.save_contact(@contact)
    end

    it "should commit the changes" do
      @disk.should_receive(:save_contact)
      @git.stub(:commit) do |message|
        message.should eq "save_contact(test)"
      end
      @git.save_contact(@contact)
    end

  end

end

