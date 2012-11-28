
require "ostruct"

describe Ppl::Adapter::Storage::Git, "#initialize" do

  before(:each) do
    FakeFS.activate!
    Dir.mkdir "/contacts"

    @disk    = double(Ppl::Adapter::Storage::Disk)
    @contact = double(Ppl::Entity::Contact)
    @repo    = double(Rugged::Repository)
    @vcard   = double(Ppl::Adapter::Vcard)

    Rugged::Repository.stub(:new).and_return(@repo)

    @disk.stub(:directory).and_return(Dir.new("/contacts"))
    @contact.stub(:id).and_return("test")

    @git = Ppl::Adapter::Storage::Git.new(@disk)
    @git.vcard_adapter = @vcard
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
      @git.repository.should be @repo
    end
  end

  describe "#load_contact" do

    it "should return a contact" do
      head        = OpenStruct.new
      head.target = "asdfg"

      @disk.should_receive(:filename_for_contact_id).and_return("/contacts/test.vcf")
      @repo.should_receive(:head).and_return(head)
      @repo.should_receive(:file_at).and_return("vcard contents")
      @vcard.should_receive(:decode).and_return(@contact)
      @contact.should_receive(:id=).with("test")

      contact = @git.load_contact("test")
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

