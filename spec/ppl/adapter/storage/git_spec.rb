
require "ostruct"

describe Ppl::Adapter::Storage::Git do

  before(:each) do
    FakeFS.activate!
    Dir.mkdir "/contacts"

    @disk    = double(Ppl::Adapter::Storage::Disk)
    @contact = double(Ppl::Entity::Contact)
    @repo    = double(Rugged::Repository)
    @commit  = double(Rugged::Commit)
    @vcard   = double(Ppl::Adapter::Vcard)
    @target  = double(Rugged::Commit)

    Rugged::Repository.stub(:new).and_return(@repo)

    @disk.stub(:directory).and_return(Dir.new("/contacts"))
    @disk.stub(:path).and_return("/contacts")
    @contact.stub(:id).and_return("test")

    @git = Ppl::Adapter::Storage::Git.new(@disk)
    @git.vcard_adapter = @vcard
  end

  after(:each) do
    FileUtils.rm_rf "/contacts"
    FakeFS.deactivate!
  end

  describe "#path" do
    it "should return the path of the repository" do
      @git.path.should eq "/contacts"
    end
  end

  describe "#initialize" do
    it "should accept a disk storage adapter" do
      @git.disk.should be @disk
    end
    it "should instantiate rugged" do
      @git.repository.should be @repo
    end
  end

  describe "#load_address_book" do

    before(:each) do
      @head = double(Rugged::Reference)

      @files = [{:name => "test.vcf"}]

      @commit.should_receive(:target).and_return(@target)
      @target.should_receive(:oid)
      @repo.should_receive(:lookup).and_return(@head)
      @repo.should_receive(:head).and_return(@commit)

      @git.stub(:load_contact) do |id|
        contact    = Ppl::Entity::Contact.new
        contact.id = id
        contact
      end

    end

    it "should return an address book" do
      @head.should_receive(:tree).and_return(@files)
      @git.load_address_book.should be_a(Ppl::Entity::AddressBook)
    end

    it "should not put anything except contacts in the address book" do
      @files = [{:name => "poop.vcf"}, {:name => ".ppl"}]
      @head.should_receive(:tree).and_return(@files)

      address_book = @git.load_address_book
      address_book.contacts.each do |contact|
        contact.should be_a(Ppl::Entity::Contact)
      end
    end

  end

  describe "#load_contact" do

    it "should return a contact" do
      target      = OpenStruct.new
      target.oid  = "asdfg"
      head        = OpenStruct.new
      head.target = target

      blob         = OpenStruct.new
      blob.content = 'vcard contents'

      @repo.should_receive(:head).and_return(head)
      @repo.should_receive(:blob_at).and_return(blob)
      @vcard.should_receive(:decode).and_return(@contact)
      @contact.should_receive(:id=).with("test")

      contact = @git.load_contact("test")
    end

    it "handles encoding errors gracefully" do
      target      = OpenStruct.new
      target.oid  = "asdfg"
      head        = OpenStruct.new
      head.target = target

      blob         = OpenStruct.new
      blob.content = 'vcard contents'

      @repo.should_receive(:head).and_return(head)
      @repo.should_receive(:blob_at).and_return(blob)
      @vcard.should_receive(:decode).and_raise(Vpim::InvalidEncodingError)
      expect{ @git.load_contact("test") }.to raise_error(Ppl::Error::InvalidVcard)
    end

  end

  describe "#save_contact" do

    it "should save the contact to disk" do
      @disk.should_receive(:save_contact).with(@contact)
      @git.stub(:add)
      @git.stub(:commit)
      @git.save_contact(@contact)
    end

    it "should commit the changes" do
      @disk.should_receive(:save_contact)
      @git.stub(:add) do |file|
        file.should eq "test.vcf"
      end
      @git.stub(:commit) do |message|
        message.should eq "save_contact(test)"
      end
      @git.save_contact(@contact)
    end

  end

end

