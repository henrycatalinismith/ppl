
describe Ppl::Command::Import do

  before(:each) do
    @command = Ppl::Command::Import.new
    @input   = Ppl::Application::Input.new
    @storage = double(Ppl::Adapter::Storage)
    @name_service = double(Ppl::Service::Name)

    @command.storage = @storage
  end

  describe "#name" do
    it "should be 'import'" do
      @command.name.should eq "import"
    end
  end

  describe "#execute" do

  end

end

