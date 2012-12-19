
describe Ppl::Command::Phone do

  before(:each) do
    @command = Ppl::Command::Phone.new
    @input   = Ppl::Application::Input.new
    @output  = Ppl::Application::Output.new(nil, nil)
    @contact = Ppl::Entity::Contact.new
    @storage = double(Ppl::Adapter::Storage)

    @show_format = double(Ppl::Format::Contact)
    @list_format = double(Ppl::Format::Contact)

    @command.storage     = @storage
    @command.show_format = @show_format
    @command.list_format = @list_format
  end

  describe "#name" do
    it "should be 'phone'" do
      @command.name.should eq "phone"
    end
  end

  describe "#execute" do

    it "should list all phone numbers if no contact ID is given" do
      @storage.should_receive(:load_address_book).and_return(@address_book)
      @list_format.should_receive(:process).and_return("all the numbers")
      @output.should_receive(:line).with("all the numbers")
      @input.arguments = []
      @command.execute(@input, @output)
    end

    it "should show the contact's phone number if no new number is given" do
      @storage.should_receive(:require_contact).and_return(@contact)
      @show_format.should_receive(:process).and_return("0123456789")
      @output.should_receive(:line).with("0123456789")
      @input.arguments = ["jim"]
      @command.execute(@input, @output).should eq true
    end

    it "should not output anything if there's nothing to show" do
      @storage.should_receive(:require_contact).and_return(@contact)
      @show_format.should_receive(:process).and_return("")
      @input.arguments = ["jim"]
      @command.execute(@input, @output).should eq false
    end

    it "should change the contact's phone number if a number is given" do
      @storage.should_receive(:require_contact).and_return(@contact)
      @storage.should_receive(:save_contact) do |contact|
        contact.phone_number.should eq "01234567890"
      end
      @input.arguments = ["jim", "01234567890"]
      @command.execute(@input, @output)
    end

  end

end

