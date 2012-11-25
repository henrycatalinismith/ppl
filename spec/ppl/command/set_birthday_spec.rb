
describe Ppl::Command::SetBirthday do

  before(:each) do
    @input   = Ppl::Application::Input.new
    @output  = Ppl::Application::Output.new(nil, nil)
    @contact = Ppl::Entity::Contact.new
    @command = Ppl::Command::SetBirthday.new
    @storage = double(Ppl::Adapter::Storage)

    @command.storage = @storage
    @contact.id = "jim"
  end

  describe "#name" do
    it "should be 'birthday'" do
      @command.name.should eq "birthday"
    end
  end

  describe "#execute" do

    it "should change the contact's birthday" do
      @storage.should_receive(:require_contact).and_return(@contact)
      @storage.should_receive(:save_contact) do |contact|
        contact.birthday.strftime.should eq "1980-01-01"
      end
      @input.arguments = ["jim", "1980-01-01"]
      @command.execute(@input, @output)
    end

    it "should raise an error if no contact ID is given" do
      @input.arguments = [nil, "1980-01-01"]
      expect{@command.execute(@input, @output)}.to raise_error(Ppl::Error::IncorrectUsage)
    end

    it "should raise an error if no birthday is given" do
      @input.arguments = ["jim"]
      expect{@command.execute(@input, @output)}.to raise_error(Ppl::Error::IncorrectUsage)
    end

    it "should raise an error if the birthday isn't a valid date" do
      @input.arguments = ["jim", "poiuytrewq"]
      expect{@command.execute(@input, @output)}.to raise_error(ArgumentError)
    end

  end

end

