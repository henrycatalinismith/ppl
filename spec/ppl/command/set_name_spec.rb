
describe Ppl::Command::SetName do

  before(:each) do
    @input   = Ppl::Application::Input.new
    @output  = Ppl::Application::Output.new(nil, nil)
    @contact = Ppl::Entity::Contact.new
    @command = Ppl::Command::SetName.new
    @storage = double(Ppl::Adapter::Storage)

    @command.storage = @storage
    @contact.id = "jim"
  end

  describe "#name" do
    it "should be 'name'" do
      @command.name.should eq "name"
    end
  end

  describe "#execute" do

    it "should change the contact's name" do
      @storage.should_receive(:require_contact).and_return(@contact)
      @storage.should_receive(:save_contact) do |contact|
        contact.name.should eq "Jim Jamieson"
      end
      @input.arguments = ["jim", "Jim Jamieson"]
      @command.execute(@input, @output)
    end

    it "should raise an error if no contact ID is given" do
      @input.arguments = [nil, "Jim Jamieson"]
      expect{@command.execute(@input, @output)}.to raise_error(Ppl::Error::IncorrectUsage)
    end

    it "should raise an error if no name is given" do
      @input.arguments = ["jim"]
      expect{@command.execute(@input, @output)}.to raise_error(Ppl::Error::IncorrectUsage)
    end

  end

end

