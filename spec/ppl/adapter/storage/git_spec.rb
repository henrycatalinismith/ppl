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

    allow(Rugged::Repository).to receive(:new).and_return(@repo)

    allow(@disk).to receive(:directory).and_return(Dir.new("/contacts"))
    allow(@disk).to receive(:path).and_return("/contacts")
    allow(@contact).to receive(:id).and_return("test")

    @git = Ppl::Adapter::Storage::Git.new(@disk)
    @git.vcard_adapter = @vcard
  end

  after(:each) do
    FileUtils.rm_rf "/contacts"
    FakeFS.deactivate!
  end

  describe "#path" do
    it "should return the path of the repository" do
      expect(@git.path).to eq "/contacts"
    end
  end

  describe "#initialize" do
    it "should accept a disk storage adapter" do
      expect(@git.disk).to be @disk
    end
    it "should instantiate rugged" do
      expect(@git.repository).to be @repo
    end
  end

  describe "#load_address_book" do

    before(:each) do
      @head = double(Rugged::Reference)

      @files = [{:name => "test.vcf"}]

      expect(@commit).to receive(:target).and_return(@target)
      expect(@target).to receive(:oid)
      expect(@repo).to receive(:lookup).and_return(@head)
      expect(@repo).to receive(:head).and_return(@commit)

      allow(@git).to receive(:load_contact) do |id|
        contact    = Ppl::Entity::Contact.new
        contact.id = id
        contact
      end

    end

    it "should return an address book" do
      expect(@head).to receive(:tree).and_return(@files)
      expect(@git.load_address_book).to be_a(Ppl::Entity::AddressBook)
    end

    it "should not put anything except contacts in the address book" do
      @files = [{:name => "poop.vcf"}, {:name => ".ppl"}]
      expect(@head).to receive(:tree).and_return(@files)

      address_book = @git.load_address_book
      address_book.contacts.each do |contact|
        expect(contact).to be_a(Ppl::Entity::Contact)
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

      expect(@repo).to receive(:head).and_return(head)
      expect(@repo).to receive(:blob_at).and_return(blob)
      expect(@vcard).to receive(:decode).and_return(@contact)
      expect(@contact).to receive(:id=).with("test")

      contact = @git.load_contact("test")
    end

    it "handles encoding errors gracefully" do
      target      = OpenStruct.new
      target.oid  = "asdfg"
      head        = OpenStruct.new
      head.target = target

      blob         = OpenStruct.new
      blob.content = 'vcard contents'

      expect(@repo).to receive(:head).and_return(head)
      expect(@repo).to receive(:blob_at).and_return(blob)
      expect(@vcard).to receive(:decode).and_raise(Vpim::InvalidEncodingError)
      expect{ @git.load_contact("test") }.to raise_error(Ppl::Error::InvalidVcard)
    end

  end

  describe "#save_contact" do

    it "should save the contact to disk" do
      expect(@disk).to receive(:save_contact).with(@contact)
      allow(@git).to receive(:add)
      allow(@git).to receive(:commit)
      @git.save_contact(@contact)
    end

    it "should commit the changes" do
      expect(@disk).to receive(:save_contact)
      allow(@git).to receive(:add) do |file|
        expect(file).to eq "test.vcf"
      end
      allow(@git).to receive(:commit) do |message|
        expect(message).to eq "save_contact(test)"
      end
      @git.save_contact(@contact)
    end

  end

end

