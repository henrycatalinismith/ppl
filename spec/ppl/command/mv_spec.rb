
describe Ppl::Command::Mv do

  before(:each) do
    @command = Ppl::Command::Mv.new
    @input   = Ppl::Application::Input.new
    @output  = double(Ppl::Application::Output)
    @contact = Ppl::Entity::Contact.new
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

    it "should raise an error if no contact is specified" do
      @input.arguments = []
      expect{@command.execute(@input, @output)}.to raise_error(Ppl::Error::IncorrectUsage)
    end

    it "should raise an error if no new ID is specified" do
      @input.arguments = ["test", nil]
      expect{@command.execute(@input, @output)}.to raise_error(Ppl::Error::IncorrectUsage)
    end

    it "should return false if the new id is taken" do
      @storage.should_receive(:require_contact).with("old").and_return(@contact)
      @storage.should_receive(:load_contact).with("new").and_return(@contact)
      @output.should_receive(:error)
      @input.arguments = ["old", "new"]

      @command.execute(@input, @output).should eq false
    end

    it "should rename the given contact" do
      @storage.should_receive(:require_contact).with("old").and_return(@contact)
      @storage.should_receive(:load_contact).with("new").and_return(nil)

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

