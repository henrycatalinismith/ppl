
describe Ppl::Command::ContactRename do

  before(:each) do
    @input   = Ppl::Application::Input.new
    @output  = Ppl::Application::Output.new(nil, nil)
    @contact = Ppl::Entity::Contact.new
    @command = Ppl::Command::ContactRename.new
    @storage = double(Ppl::Adapter::Storage)

    @command.storage = @storage
    @contact.id = "old"
  end

  describe "#name" do
    it "should be 'mv'" do
      @command.name.should eq "mv"
    end
  end

  describe "#execute" do

    it "should rename the given contact" do
      @storage.should_receive(:require_contact).and_return(@contact)

      @storage.should_receive(:delete_contact).with(@contact) do |contact|
        contact.id.should eq "old"
      end

      @storage.should_receive(:save_contact).with(@contact) do |contact|
        contact.id.should eq "new"
      end

      @input.arguments = ["old", "new"]

      @command.execute(@input, @output)
    end

  end

end

