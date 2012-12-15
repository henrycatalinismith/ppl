
describe Ppl::Command::Phone do

  before(:each) do
    @command = Ppl::Command::Phone.new
    @input   = Ppl::Application::Input.new
    @output  = Ppl::Application::Output.new(nil, nil)
    @contact = Ppl::Entity::Contact.new
    @storage = double(Ppl::Adapter::Storage)
    @format  = double(Ppl::Format::Contact)

    @command.storage = @storage
    @command.format  = @format
  end

  describe "#name" do
    it "should be 'phone'" do
      @command.name.should eq "phone"
    end
  end

  describe "#execute" do

    it "should raise an error if no contact ID is given" do
      @input.arguments = [nil, "01234567890"]
      expect{@command.execute(@input, @output)}.to raise_error(Ppl::Error::IncorrectUsage)
    end

    it "should show the contact's phone number if no new number is given" do
      @storage.should_receive(:require_contact).and_return(@contact)
      @format.should_receive(:process).and_return("0123456789")
      @output.should_receive(:line).with("0123456789")
      @input.arguments = ["jim"]
      @command.execute(@input, @output)
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

