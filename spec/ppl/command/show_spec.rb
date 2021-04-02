describe Ppl::Command::Show do

  before(:each) do
    @command = Ppl::Command::Show.new
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
      expect(@command.name).to eq "show"
    end
  end

  describe "#execute" do

    it "should raise an error if no contact is specified" do
      @input.arguments = []
      expect{@command.execute(@input, @output)}.to raise_error(Ppl::Error::IncorrectUsage)
    end

    it "should show the contact's name" do
      expect(@storage).to receive(:require_contact).and_return(@contact)
      expect(@format).to receive(:process).and_return("John Doe")

      @input.arguments = ["john"]

      expect(@output).to receive(:line).with("John Doe")
      @command.execute(@input, @output)
    end
  end

end

