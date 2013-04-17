
describe Ppl::Command::Scrape do

  before(:each) do
    @command = Ppl::Command::Scrape.new
    @input   = Ppl::Application::Input.new
    @output  = double(Ppl::Application::Output)
    @storage = double(Ppl::Adapter::Storage)
    @address_book = double(Ppl::Entity::AddressBook)
    @command.storage  = @storage
  end

  describe "#name" do
    it "should be 'scrape'" do
      @command.name.should eq "scrape"
    end
  end

  describe "#execute" do
  end

end

