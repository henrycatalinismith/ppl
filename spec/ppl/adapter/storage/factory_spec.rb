
describe Ppl::Adapter::Storage::Factory do

  before(:each) do
    @factory = Ppl::Adapter::Storage::Factory.new
  end

  describe "#load_adapter" do

    it "should return a disk adapter by default" do
    end

    it "should return a git adapter if the directory is a git repository" do
    end

  end

end

