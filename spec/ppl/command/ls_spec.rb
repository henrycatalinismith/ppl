describe Ppl::Command::Ls do

  before(:each) do
    @command = Ppl::Command::Ls.new
    @input   = Ppl::Application::Input.new
    @output  = double(Ppl::Application::Output)
    @storage = double(Ppl::Adapter::Storage)
    @format  = double(Ppl::Format::AddressBook)
    @custom  = double(Ppl::Format::Custom)
    @address_book = double(Ppl::Entity::AddressBook)

    @command.custom_format  = @custom
    @command.default_format = @format
    @command.storage        = @storage
  end

  describe "#name" do
    it "should be 'ls'" do
      @command.name.should eq "ls"
    end
  end

  describe "#execute" do

    before(:each) do
      @storage.should_receive(:load_address_book).and_return(@address_book)
    end

    after(:each) do
      @command.execute(@input, @output)
    end

    it "should show the list of contacts in the address book" do
      @format.should_receive(:process).and_return("list of contacts")
      @output.should_receive(:line).with("list of contacts")
    end

    it "should let the user specify a preset pretty format" do
      @input.options[:pretty] = "test"
      @address_book.should_receive(:contacts).and_return([1])
      @custom.should_receive(:use_preset).with("test")
      @custom.should_receive(:process).and_return("list of contacts")
      @output.should_receive(:line).with("list of contacts")
    end

    it "should let the user specify a custom format" do
      @input.options[:format] = "%n"
      @address_book.should_receive(:contacts).and_return([1])
      @custom.should_receive(:format=).with("%n")
      @custom.should_receive(:process).and_return("list of contacts")
      @output.should_receive(:line).with("list of contacts")
    end

  end

end

