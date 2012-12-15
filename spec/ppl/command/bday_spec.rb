
describe Ppl::Command::Bday do

  before(:each) do
    @input   = Ppl::Application::Input.new
    @output  = Ppl::Application::Output.new(nil, nil)
    @contact = Ppl::Entity::Contact.new
    @command = Ppl::Command::Bday.new
    @storage = double(Ppl::Adapter::Storage)
    @format  = double(Ppl::Format::Contact)

    @command.storage = @storage
    @command.format  = @format
    @contact.id = "jim"
  end

  describe "#name" do
    it "should be 'bday'" do
      @command.name.should eq "bday"
    end
  end

  describe "#execute" do

    it "should raise an error if no contact ID is given" do
      @input.arguments = [nil, "1980-01-01"]
      expect{@command.execute(@input, @output)}.to raise_error(Ppl::Error::IncorrectUsage)
    end

    it "should raise an error if the date given isn't a valid date" do
      @storage.should_receive(:require_contact).and_return(@contact)
      @input.arguments = ["jim", "poiuytrewq"]
      expect{@command.execute(@input, @output)}.to raise_error(Ppl::Error::IncorrectUsage)
    end

    it "should show the contact's birthday if no date is given" do
      @storage.should_receive(:require_contact).and_return(@contact)
      @format.should_receive(:process).and_return("1970-01-01")
      @output.should_receive(:line).with("1970-01-01")
      @input.arguments = ["jim"]
      @command.execute(@input, @output)
    end

    it "should change the contact's birthday if a date is given" do
      @storage.should_receive(:require_contact).and_return(@contact)
      @storage.should_receive(:save_contact) do |contact|
        contact.birthday.strftime.should eq "1980-01-01"
      end
      @input.arguments = ["jim", "1980-01-01"]
      @command.execute(@input, @output)
    end

  end

end

