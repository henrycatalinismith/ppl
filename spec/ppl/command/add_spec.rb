describe Ppl::Command::Add do

  before(:each) do
    @command = Ppl::Command::Add.new
    @input   = Ppl::Application::Input.new
    @storage = double(Ppl::Adapter::Storage)
    @name_service = double(Ppl::Service::Name)

    @command.storage = @storage
    @command.name_service = @name_service
  end

  describe "#name" do
    it "should be 'add'" do
      expect(@command.name).to eq "add"
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
      expect(@storage).to receive(:save_contact) do |contact|
        expect(contact.id).to eq "john"
        expect(contact.name).to be_a(Ppl::Entity::Name)
      end
      expect(@name_service)
        .to receive(:parse)
        .with("John Doe")
        .and_return(Ppl::Entity::Name.new)
      @input.arguments = ["john", "John Doe"]
      @command.execute(@input, nil)
    end

  end

end

