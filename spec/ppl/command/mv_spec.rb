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
      expect(@command.name).to eq "mv"
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
      expect(@storage).to receive(:require_contact).with("old").and_return(@contact)
      expect(@storage).to receive(:load_contact).with("new").and_return(@contact)
      expect(@output).to receive(:error)
      @input.arguments = ["old", "new"]

      expect(@command.execute(@input, @output)).to eq false
    end

    it "should rename the given contact" do
      expect(@storage).to receive(:require_contact).with("old").and_return(@contact)
      expect(@storage).to receive(:load_contact).with("new").and_return(nil)

      expect(@storage).to receive(:delete_contact).with(@contact) do |contact|
        expect(contact.id).to eq "old"
      end

      expect(@storage).to receive(:save_contact).with(@contact) do |contact|
        expect(contact.id).to eq "new"
      end

      @input.arguments = ["old", "new"]

      @command.execute(@input, @output)
    end

  end

end

