
describe Ppl::Command::Post do

  before(:each) do
    @input   = Ppl::Application::Input.new
    @output  = Ppl::Application::Output.new(nil, nil)
    @contact = Ppl::Entity::Contact.new
    @command = Ppl::Command::Post.new
    @storage = double(Ppl::Adapter::Storage)

    @list_format = double(Ppl::Format::Contact)
    @show_format = double(Ppl::Format::Contact)

    @command.storage     = @storage
    @command.show_format = @show_format
    @command.list_format = @list_format
    @contact.id = "jim"
  end

  describe "#name" do
    it "should be 'post'" do
      @command.name.should eq "post"
    end
  end

  describe "#execute" do

    it "should list all postal addresses if no contact ID is given" do
      @storage.should_receive(:load_address_book).and_return(@address_book)
      @list_format.should_receive(:process).and_return("all the postal addresses")
      @output.should_receive(:line).with("all the postal addresses")
      @input.arguments = []
      @command.execute(@input, @output)
    end

    it "should show the current address if no new address is given" do
      @storage.should_receive(:require_contact).and_return(@contact)
      @show_format.should_receive(:process).and_return("1 Test Road")
      @output.should_receive(:line).with("1 Test Road")
      @input.arguments = ["jim"]
      @command.execute(@input, @output).should eq true
    end

    it "should not output anything if there's nothing to show" do
      @storage.should_receive(:require_contact).and_return(@contact)
      @show_format.should_receive(:process).and_return("")
      @input.arguments = ["jim"]
      @command.execute(@input, @output).should eq false
    end

    it "should change the contact's postal address if an address is given" do
      @storage.should_receive(:require_contact).and_return(@contact)
      @storage.should_receive(:save_contact) do |contact|
        contact.postal_address.should eq "1 Test Road"
      end
      @input.arguments = ["jim", "1 Test Road"]
      @command.execute(@input, @output)
    end

  end

end

