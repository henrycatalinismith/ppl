
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
      @command.name.should eq "age"
    end
  end

  describe "#execute" do

    it "should list contacts' ages if no arguments are given" do
      @storage.should_receive(:load_address_book)
      @list_format.should_receive(:process)
      @output.should_receive(:line)
      @command.execute(@input, @output)
    end

    it "should show a single contact's ages if one is specified" do
      @input.arguments = ["jdoe"]
      @storage.should_receive(:require_contact)
      @show_format.should_receive(:process)
      @output.should_receive(:line)
      @command.execute(@input, @output)
    end

  end

end

