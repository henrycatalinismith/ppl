describe Ppl::Adapter::Storage::Factory do

  before(:each) do
    FakeFS.activate!
    Dir.mkdir "/contacts"

    @factory   = Ppl::Adapter::Storage::Factory.new(nil)
    @directory = Dir.new("/contacts")
    @repo      = double(Rugged::Repository)

    allow(Rugged::Repository).to receive(:new).and_return(@repo)
  end

  after(:each) do
    FileUtils.rm_rf "/contacts"
    FakeFS.deactivate!
  end

  describe "#load_adapter" do

    it "should return a disk adapter by default" do
      expect(@factory.load_adapter(@directory)).to be_a(Ppl::Adapter::Storage::Disk)
    end

    it "should return a git adapter if the directory is a git repository" do
      Dir.mkdir "/contacts/.git"
      expect(@factory.load_adapter(@directory)).to be_a(Ppl::Adapter::Storage::Git)
    end

  end

end

