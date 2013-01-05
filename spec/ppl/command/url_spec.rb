
describe Ppl::Command::Url do

  before(:each) do
    @command = Ppl::Command::Url.new
    @input   = Ppl::Application::Input.new
    @output  = Ppl::Application::Output.new(nil, nil)
    @contact = Ppl::Entity::Contact.new
    @storage = double(Ppl::Adapter::Storage)

    @list_format = double(Ppl::Format::Contact)
    @show_format = double(Ppl::Format::Contact)

    @command.storage     = @storage
    @command.show_format = @show_format
    @command.list_format = @list_format
    @contact.id = "jim"
  end

  describe "#name" do
    it "should be 'url'" do
      @command.name.should eq "url"
    end
  end

  describe "#execute" do

    it "should list all URLs if no contact ID is given" do
      @storage.should_receive(:load_address_book).and_return(@address_book)
      @list_format.should_receive(:process).and_return("all the URLs")
      @output.should_receive(:line).with("all the URLs")
      @input.arguments = []
      @command.execute(@input, @output)
    end

    it "should show the current URLs if no new URL is given" do
      @storage.should_receive(:require_contact).and_return(@contact)
      @show_format.should_receive(:process).and_return("http://example.org/~jdoe")
      @output.should_receive(:line).with("http://example.org/~jdoe")
      @input.arguments = ["jim"]
      @command.execute(@input, @output).should eq true
    end

    it "should not output anything if there's nothing to show" do
      @storage.should_receive(:require_contact).and_return(@contact)
      @show_format.should_receive(:process).and_return("")
      @input.arguments = ["jim"]
      @command.execute(@input, @output).should eq false
    end

    it "should delete the given URL from the contact if requested" do
      @contact.urls.push("http://example.org/~jdoe")
      @contact.urls.push("http://example.com/~jdoe")
      @storage.should_receive(:require_contact).and_return(@contact)
      @storage.should_receive(:save_contact) do |contact|
        contact.urls.should eq ["http://example.com/~jdoe"]
      end
      @input.arguments = ["jim", "http://example.org/~jdoe"]
      @input.options   = { :delete => true }
      @command.execute(@input, @output)
    end

    it "should raise an error when deleting a non-existent URL" do
      @contact.urls.push("http://example.org/~jdoe")
      @contact.urls.push("http://example.com/~jdoe")
      @storage.should_receive(:require_contact).and_return(@contact)
      @input.arguments = ["jim", "http://example.net/~jdoe"]
      @input.options   = { :delete => true }
      expect{@command.execute(@input, nil)}.to raise_error(Ppl::Error::IncorrectUsage)
    end

    it "should add the given URL to the contact if it's new" do
      @storage.should_receive(:require_contact).and_return(@contact)
      @storage.should_receive(:save_contact) do |contact|
        contact.urls.first.should eq "http://example.org/~jdoe"
      end
      @input.arguments = ["jim", "http://example.org/~jdoe"]
      @command.execute(@input, @output)
    end

    it "should raise an error if the user is adding a duplicate address" do
      @contact.urls.push "http://example.org/~jdoe"
      @storage.should_receive(:require_contact).and_return(@contact)
      @input.arguments = ["jim", "http://example.org/~jdoe"]
      expect{@command.execute(@input, nil)}.to raise_error(Ppl::Error::IncorrectUsage)
    end

  end

end

