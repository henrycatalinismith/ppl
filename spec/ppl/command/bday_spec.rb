describe Ppl::Command::Bday do

  before(:each) do
    @input   = Ppl::Application::Input.new
    @output  = Ppl::Application::Output.new(nil, nil)
    @contact = Ppl::Entity::Contact.new
    @command = Ppl::Command::Bday.new
    @storage = double(Ppl::Adapter::Storage)
    @show_format  = double(Ppl::Format::Contact)

    @command.storage = @storage
    @command.show_format  = @show_format
    @contact.id = "jim"
  end

  describe "#name" do
    it "should be 'bday'" do
      expect(@command.name).to eq "bday"
    end
  end

  describe "#execute" do

    it "should show the contact's birthday if no date is given" do
      expect(@storage).to receive(:require_contact).and_return(@contact)
      expect(@show_format).to receive(:process).and_return("1970-01-01")
      expect(@output).to receive(:line).with("1970-01-01")
      @input.arguments = ["jim"]
      expect(@command.execute(@input, @output)).to eq true
    end

    it "should not output anything if there's no birthday to show" do
      expect(@storage).to receive(:require_contact).and_return(@contact)
      expect(@show_format).to receive(:process).and_return("")
      @input.arguments = ["jim"]
      expect(@command.execute(@input, @output)).to eq false
    end

    it "should change the contact's birthday if a date is given" do
      expect(@storage).to receive(:require_contact).and_return(@contact)
      expect(@storage).to receive(:save_contact) do |contact|
        expect(contact.birthday.strftime).to eq "1980-01-01"
      end
      @input.arguments = ["jim", "1980-01-01"]
      @command.execute(@input, @output)
    end

  end

end

