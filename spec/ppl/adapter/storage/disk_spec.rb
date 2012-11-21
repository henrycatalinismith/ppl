
describe Ppl::Adapter::Storage::Disk, "#initialize" do

  it "should accept a path" do
    @storage = Ppl::Adapter::Storage::Disk.new("/tmp")
    @storage.path.should eq "/tmp"
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
    @storage = Ppl::Adapter::Storage::Disk.new("/contacts")
    @adapter = double(Ppl::Adapter::Vcard)
    @contact = Ppl::Entity::Contact.new
    @storage.vcard_adapter = @adapter

    FakeFS.activate!
    Dir.mkdir "/contacts"
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
      FileUtils.touch "/contacts/one.vcard"
      FileUtils.touch "/contacts/two.vcard"

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
      FileUtils.touch "/contacts/one.vcard"
      @adapter.should_receive(:decode).once.and_return(@contact)
      @storage.load_contact("one").should be_a(Ppl::Entity::Contact)
    end

  end

end

