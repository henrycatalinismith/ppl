
describe Ppl::Command::Post do

  before(:each) do
    @input   = Ppl::Application::Input.new
    @output  = Ppl::Application::Output.new(nil, nil)
    @contact = Ppl::Entity::Contact.new
    @command = Ppl::Command::Post.new
    @storage = double(Ppl::Adapter::Storage)
    @service = double(Ppl::Service::PostalAddress)

    @address_book_format = double(Ppl::Format::Contact)
    @contact_format = double(Ppl::Format::Contact)

    @command.address_service = @service
    @command.storage     = @storage
    @command.contact_format = @contact_format
    @command.address_book_format = @address_book_format
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
      @address_book_format.should_receive(:process).and_return("all the postal addresses")
      @output.should_receive(:line).with("all the postal addresses")
      @input.arguments = []
      @command.execute(@input, @output)
    end

    it "should show the current address if no new address is given" do
      @storage.should_receive(:require_contact).and_return(@contact)
      @contact_format.should_receive(:process).and_return("1 Test Road")
      @output.should_receive(:line).with("1 Test Road")
      @input.arguments = ["jim"]
      @command.execute(@input, @output).should eq true
    end

    it "should not output anything if there's nothing to show" do
      @storage.should_receive(:require_contact).and_return(@contact)
      @contact_format.should_receive(:process).and_return("")
      @input.arguments = ["jim"]
      @command.execute(@input, @output).should eq false
    end

  end

end

