
describe Ppl::Command::Org do

  before(:each) do
    @command = Ppl::Command::Org.new
    @input   = Ppl::Application::Input.new
    @output  = Ppl::Application::Output.new(nil, nil)
    @contact = Ppl::Entity::Contact.new
    @storage = double(Ppl::Adapter::Storage)

    @show_format = double(Ppl::Format::Contact)
    @list_format = double(Ppl::Format::Contact)

    @command.storage     = @storage
    @command.show_format = @show_format
    @command.list_format = @list_format

    @contact.id = "tim"
  end

  describe "#name" do
    it "should be 'org'" do
      @command.name.should eq "org"
    end
  end

  describe "#execute" do

    it "should list all organizations if no contact ID is given" do
      @storage.should_receive(:load_address_book).and_return(@address_book)
      @list_format.should_receive(:process).and_return("all the organizations")
      @output.should_receive(:line).with("all the organizations")
      @input.arguments = []
      @command.execute(@input, @output)
    end

    it "should show the contact's organization if no new organization is given" do
      @storage.should_receive(:require_contact).and_return(@contact)
      @show_format.should_receive(:process).and_return("Example Ltd")
      @output.should_receive(:line).with("Example Ltd")
      @input.arguments = ["jim"]
      @command.execute(@input, @output)
    end

    it "should change the contact's organization if one is given" do
      @storage.should_receive(:require_contact).and_return(@contact)
      @storage.should_receive(:save_contact) do |contact|
        contact.organization.should eq "Example Ltd"
      end
      @input.arguments = ["jim", "Example Ltd"]
      @command.execute(@input, @output)
    end

  end

end

