
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
    @storage.vcard_adapter = @adapter

    FakeFS.activate!
    Dir.mkdir "/contacts"
  end

  after(:each) do
    FakeFS.deactivate!
  end

  it "is cool to swear" do
  end

end

