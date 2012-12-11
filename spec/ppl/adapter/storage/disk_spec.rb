
describe Ppl::Adapter::Storage::Disk, "#create_address_book" do

  before(:each) do
    FakeFS.activate!
  end

  after(:each) do
    FakeFS.deactivate!
  end

  describe "#create_address_book" do
    it "should create the directory if it doesn't exist yet" do
      Ppl::Adapter::Storage::Disk.create_address_book("/contacts")
      Dir.exists?("/contacts").should eq true
      FileUtils.rm_rf("/contacts")
    end
  end

end

describe Ppl::Adapter::Storage::Disk, "#initialize" do

  it "should accept a Dir object" do
    directory = Dir.new("/tmp")
    @storage = Ppl::Adapter::Storage::Disk.new(directory)
    @storage.directory.should be directory
  end

end

describe Ppl::Adapter::Storage::Disk do

  before(:each) do
    @storage = Ppl::Adapter::Storage::Disk.new(nil)
  end

  describe "#vcard_adapter=" do
    it "should accept a vcard adapter" do
      adapter = double(Ppl::Adapter::Vcard)
      @storage.vcard_adapter = adapter
      @storage.vcard_adapter.should be adapter
    end
  end

end

describe Ppl::Adapter::Storage::Disk do

  before(:each) do
    FakeFS.activate!

    Dir.mkdir "/contacts"
    directory = Dir.new("/contacts")

    @storage = Ppl::Adapter::Storage::Disk.new(directory)
    @adapter = double(Ppl::Adapter::Vcard)
    @contact = Ppl::Entity::Contact.new
    @storage.vcard_adapter = @adapter
  end

  after(:each) do
    FileUtils.rm_rf "/contacts"
    FakeFS.deactivate!
  end

  describe "#load_address_book" do

    it "should return a Ppl::Entity::AddressBook" do
      @storage.load_address_book.should be_a(Ppl::Entity::AddressBook)
    end

    it "should fill the address book with the contacts in the directory" do
      FileUtils.touch "/contacts/one.vcf"
      FileUtils.touch "/contacts/two.vcf"

      @adapter.should_receive(:decode).twice

      address_book = @storage.load_address_book
      address_book.count.should eq 2
    end

  end

  describe "#load_contact" do

    it "should return nil if the given contact doesn't exist" do
      @storage.load_contact("xyz").should be nil
    end

    it "should return a Ppl::Entity::Contact" do
      FileUtils.touch "/contacts/one.vcf"
      @adapter.should_receive(:decode).once.and_return(@contact)
      @storage.load_contact("one").should be_a(Ppl::Entity::Contact)
    end

    it "should populate the contact's id" do
      FileUtils.touch "/contacts/one.vcf"
      @adapter.should_receive(:decode).once.and_return(@contact)
      @storage.load_contact("one").id.should eq "one"
    end

  end

  describe "#save_contact" do

    it "should write the contact to disk" do
      @adapter.should_receive(:encode).with(@contact).and_return("asdfg")

      @contact.id = "test"
      @storage.save_contact(@contact)

      File.read("/contacts/test.vcf").should eq "asdfg"
    end

  end

  describe "#delete_contact" do
    it "should remove the the contact from the disk" do
      FileUtils.touch "/contacts/test.vcf"
      @contact.id = "test"
      @storage.delete_contact(@contact)
      File.exists?("/contacts/test.vcf").should eq false
    end
  end

  describe "#filename_for_contact" do
    it "should base the filename on the contact's id" do
      @contact.id = "test"
      @storage.filename_for_contact(@contact).should eq "/contacts/test.vcf"
    end
  end

  describe "#filename_for_contact_id" do
    it "should base the filename on the directory path" do
      @storage.filename_for_contact_id("test").should eq "/contacts/test.vcf"
    end
  end

end

