
describe Ppl::Adapter::Storage::Git, "#initialize" do

  before(:each) do
    FakeFS.activate!
    Dir.mkdir "/contacts"

    @disk    = double(Ppl::Adapter::Storage::Disk)
    @contact = double(Ppl::Entity::Contact)
    @rugged  = double(Rugged::Repository)

    Rugged::Repository.stub(:new).and_return(@rugged)

    @disk.stub(:directory).and_return(Dir.new("/contacts"))
    @contact.stub(:id).and_return("test")

    @git = Ppl::Adapter::Storage::Git.new(@disk)
  end

  after(:each) do
    FileUtils.rm_rf "/contacts"
    FakeFS.deactivate!
  end

  describe "#initialize" do
    it "should accept a disk storage adapter" do
      @git.disk.should be @disk
    end
    it "should instantiate rugged" do
      @git.repository.should be @rugged
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

