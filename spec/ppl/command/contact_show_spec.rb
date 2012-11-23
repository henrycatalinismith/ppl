
describe Ppl::Command::ContactShow do

  before(:each) do
    @command = Ppl::Command::ContactShow.new
    @input   = Ppl::Application::Input.new
    @output  = double(Ppl::Application::Output)
    @contact = Ppl::Entity::Contact.new
    @name    = Ppl::Entity::Name.new
    @storage = double(Ppl::Adapter::Storage)

    @command.storage = @storage
    @contact.name    = @name
  end

  describe "#name" do
    it "should be 'show'" do
      @command.name.should eq "show"
    end
  end

  describe "#execute" do
    it "should show the contact's name" do
      @storage.should_receive(:require_contact).and_return(@contact)

      @contact.name.full = "John Doe"

      @output.should_receive(:line).with("John Doe")

      @command.execute(@input, @output)
    end
  end

end

