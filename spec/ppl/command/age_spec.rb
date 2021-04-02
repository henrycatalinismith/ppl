describe Ppl::Command::Age do

  before(:each) do
    @command = Ppl::Command::Age.new
    @input   = Ppl::Application::Input.new
    @output      = double(Ppl::Application::Output)
    @storage     = double(Ppl::Adapter::Storage)
    @list_format = double(Ppl::Format::AddressBook)
    @show_format = double(Ppl::Format::Contact)

    @command.list_format = @list_format
    @command.show_format = @show_format
    @command.storage     = @storage
  end

  describe "#name" do
    it "should be 'age'" do
      expect(@command.name).to eq "age"
    end
  end

  describe "#execute" do

    it "should list contacts' ages if no arguments are given" do
      expect(@storage).to receive(:load_address_book)
      expect(@list_format).to receive(:process)
      expect(@output).to receive(:line)
      @command.execute(@input, @output)
    end

    it "should show a single contact's ages if one is specified" do
      @input.arguments = ["jdoe"]
      expect(@storage).to receive(:require_contact)
      expect(@show_format).to receive(:process)
      expect(@output).to receive(:line)
      @command.execute(@input, @output)
    end

  end

end

