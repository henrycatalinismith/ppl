
describe Ppl::Command::Post do

  before(:each) do
    @input   = Ppl::Application::Input.new
    @output  = Ppl::Application::Output.new(nil, nil)
    @contact = Ppl::Entity::Contact.new
    @command = Ppl::Command::Post.new
    @storage = double(Ppl::Adapter::Storage)
    @service = double(Ppl::Service::PostalAddress)

    @list_format = double(Ppl::Format::Contact)
    @show_format = double(Ppl::Format::Contact)

    @command.address_service = @service
    @command.storage     = @storage
    @command.show_format = @show_format
    @command.list_format = @list_format
    @contact.id = "jim"
  end

  describe "#name" do
    it "should be 'post'" do
      @command.name.should eq "post"
    end
  end

  describe "#execute" do

    it "should list all postal addresses if no contact ID is given" do
      @storage.should_receive(:load_address_book).and_return(@address_book)
      @list_format.should_receive(:process).and_return("all the postal addresses")
      @output.should_receive(:line).with("all the postal addresses")
      @input.arguments = []
      @command.execute(@input, @output)
    end

    it "should show the current address if no new address is given" do
      @storage.should_receive(:require_contact).and_return(@contact)
      @show_format.should_receive(:process).and_return("1 Test Road")
      @output.should_receive(:line).with("1 Test Road")
      @input.arguments = ["jim"]
      @command.execute(@input, @output).should eq true
    end

    it "should not output anything if there's nothing to show" do
      @storage.should_receive(:require_contact).and_return(@contact)
      @show_format.should_receive(:process).and_return("")
      @input.arguments = ["jim"]
      @command.execute(@input, @output).should eq false
    end

  end

  describe "#execute" do
    
    before(:each) do
      @input.arguments = ["jim"]
      @storage.should_receive(:require_contact).and_return(@contact)
    end

    it "should change the contact's street address if it's given" do
      @input.options = {:street => "1 Test Road"}
      @storage.should_receive(:save_contact) do |contact|
        contact.postal_address.street.should eq "1 Test Road"
      end
      @command.execute(@input, @output)
    end

    it "should change the contact's postal code if it's given" do
      @input.options = {:postal_code => "L7 8AA"}
      @storage.should_receive(:save_contact) do |contact|
        contact.postal_address.postal_code.should eq "L7 8AA"
      end
      @command.execute(@input, @output)
    end

    it "should change the contact's po box if it's given" do
      @input.options = {:po_box => "124578"}
      @storage.should_receive(:save_contact) do |contact|
        contact.postal_address.po_box.should eq "124578"
      end
      @command.execute(@input, @output)
    end

    it "should change the contact's country if it's given" do
      @input.options = {:country => "UK"}
      @storage.should_receive(:save_contact) do |contact|
        contact.postal_address.country.should eq "UK"
      end
      @command.execute(@input, @output)
    end

    it "should change the contact's locality if it's given" do
      @input.options = {:locality => "Liverpool"}
      @storage.should_receive(:save_contact) do |contact|
        contact.postal_address.locality.should eq "Liverpool"
      end
      @command.execute(@input, @output)
    end

    it "should change the contact's region if it's given" do
      @input.options = {:region => "North West"}
      @storage.should_receive(:save_contact) do |contact|
        contact.postal_address.region.should eq "North West"
      end
      @command.execute(@input, @output)
    end

  end

end

