
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
      @command.name.should eq "bday"
    end
  end

  describe "#execute" do

    it "should show the contact's birthday if no date is given" do
      @storage.should_receive(:require_contact).and_return(@contact)
      @show_format.should_receive(:process).and_return("1970-01-01")
      @output.should_receive(:line).with("1970-01-01")
      @input.arguments = ["jim"]
      @command.execute(@input, @output).should eq true
    end

    it "should not output anything if there's no birthday to show" do
      @storage.should_receive(:require_contact).and_return(@contact)
      @show_format.should_receive(:process).and_return("")
      @input.arguments = ["jim"]
      @command.execute(@input, @output).should eq false
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

