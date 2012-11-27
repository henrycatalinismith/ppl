
describe Ppl::Command::ContactShow do

  before(:each) do
    @command = Ppl::Command::ContactShow.new
    @input   = Ppl::Application::Input.new
    @output  = double(Ppl::Application::Output)
    @contact = Ppl::Entity::Contact.new
    @storage = double(Ppl::Adapter::Storage)
    @format  = double(Ppl::Format::Contact)

    @command.storage = @storage
    @command.format  = @format
  end

  describe "#name" do
    it "should be 'show'" do
      @command.name.should eq "show"
    end
  end

  describe "#execute" do
    it "should show the contact's name" do
      @storage.should_receive(:require_contact).and_return(@contact)
      @format.should_receive(:process).and_return("John Doe")

      @output.should_receive(:line).with("John Doe")
      #@output.should_receive(:line).with("johndoe@example.org")

      @command.execute(@input, @output)
    end
  end

end

