
describe Ppl::Command::ContactRename do

  before(:each) do
    @input   = Ppl::Application::Input.new
    @output  = double(Ppl::Application::Output)
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

    it "should return false if the new id is taken" do
      @storage.should_receive(:require_contact).with("old").and_return(@contact)
      @storage.should_receive(:require_contact).with("new").and_return(@contact)
      @output.should_receive(:error)
      @input.arguments = ["old", "new"]

      @command.execute(@input, @output).should eq false
    end

    it "should rename the given contact" do
      @storage.should_receive(:require_contact).with("old").and_return(@contact)
      @storage.should_receive(:require_contact).with("new").and_return(nil)

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

