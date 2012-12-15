
describe Ppl::Command::Org do

  before(:each) do
    @command = Ppl::Command::Org.new
    @input   = Ppl::Application::Input.new
    @output  = Ppl::Application::Output.new(nil, nil)
    @contact = Ppl::Entity::Contact.new
    @storage = double(Ppl::Adapter::Storage)
    @format  = double(Ppl::Format::Contact)

    @command.storage = @storage
    @contact.id = "tim"
  end

  describe "#name" do
    it "should be 'org'" do
      @command.name.should eq "org"
    end
  end

  describe "#execute" do

    it "should raise an error if no contact ID is given" do
      @input.arguments = [nil, "Example Ltd"]
      expect{@command.execute(@input, @output)}.to raise_error(Ppl::Error::IncorrectUsage)
    end

    it "should raise an error if no organization is given" do
      @input.arguments = ["jim"]
      expect{@command.execute(@input, @output)}.to raise_error(Ppl::Error::IncorrectUsage)
    end

    it "should change the contact's organization" do
      @storage.should_receive(:require_contact).and_return(@contact)
      @storage.should_receive(:save_contact) do |contact|
        contact.organization.should eq "Example Ltd"
      end
      @input.arguments = ["jim", "Example Ltd"]
      @command.execute(@input, @output)
    end

  end

end
