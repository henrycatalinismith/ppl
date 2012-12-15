
describe Ppl::Command::Add do

  before(:each) do
    @command = Ppl::Command::Add.new
    @input   = Ppl::Application::Input.new
    @storage = double(Ppl::Adapter::Storage)

    @command.storage = @storage
  end

  describe "#name" do
    it "should be 'add'" do
      @command.name.should eq "add"
    end
  end

  describe "#execute" do

    it "should raise a Ppl::Error::IncorrectUsage if no id is given" do
      expect{@command.execute(@input, nil)}.to raise_error(Ppl::Error::IncorrectUsage)
    end

    it "should raise a Ppl::Error::IncorrectUsage if no name is given" do
      @input.arguments = ["some_id"]
      expect{@command.execute(@input, nil)}.to raise_error(Ppl::Error::IncorrectUsage)
    end

    it "should save a new contact" do
      @storage.should_receive(:save_contact) do |contact|
        contact.id.should eq "john"
        contact.name.should eq "John Doe"
      end
      @input.arguments = ["john", "John Doe"]
      @command.execute(@input, nil)
    end

  end

end

