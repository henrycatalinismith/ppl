
describe Ppl::Command::Post do

  before(:each) do
    @input   = Ppl::Application::Input.new
    @output  = Ppl::Application::Output.new(nil, nil)
    @contact = Ppl::Entity::Contact.new
    @command = Ppl::Command::Post.new
    @storage = double(Ppl::Adapter::Storage)
    @service = double(Ppl::Service::PostalAddress)

    @address_book_format = double(Ppl::Format::AddressBook)
    @contact_format = double(Ppl::Format::Contact)
    @postal_address_format = double(Ppl::Format::PostalAddress)

    @command.address_service = @service
    @command.storage     = @storage
    @command.contact_format = @contact_format
    @command.address_book_format = @address_book_format
    @command.postal_address_format = @postal_address_format
    @contact.id = "jim"

    @address = Ppl::Entity::PostalAddress.new
    @address.id = "home"
    @contact.postal_addresses << @address
  end

  describe "#name" do
    it "should be 'post'" do
      @command.name.should eq "post"
    end
  end

  describe "#execute" do

    context "show address book" do

      before { @input.arguments = [] }

      it "displays postal address information for the whole address book" do
        @storage.should_receive(:load_address_book).and_return(@address_book)
        @address_book_format.should_receive(:process).and_return("all the postal addresses")
        @output.should_receive(:line).with("all the postal addresses")
        @input.arguments = []
        @command.execute(@input, @output)
      end
    end

    context "show contact" do

      before { @input.arguments = ["jim"] }

      it "shows all of a contact's postal addresses" do
        @storage.should_receive(:require_contact).and_return(@contact)
        @contact_format.should_receive(:process).and_return("1 Test Road")
        @output.should_receive(:line).with("1 Test Road")
        @command.execute(@input, @output).should eq true
      end

      it "outputs nothing if the contact has no addresses" do
        @storage.should_receive(:require_contact).and_return(@contact)
        @contact_format.should_receive(:process).and_return("")
        @command.execute(@input, @output).should eq false
      end

    end

    context "show postal address" do

      before { @input.arguments = ["jim", "home"] }

      it "shows a single postal address" do
        @storage.should_receive(:require_contact).and_return(@contact)
        @postal_address_format.should_receive(:process).with(@address).and_return("1 Test Road")
        @output.should_receive(:line).with("1 Test Road")
        @command.execute(@input, @output).should eq true
      end

      it "raises an error if there's no such address" do
        @input.arguments[1] = "other"
        @storage.should_receive(:require_contact).and_return(@contact)
        expect{@command.execute(@input, @output).should eq true}.to raise_error(Ppl::Error::PostalAddressNotFound)
      end

    end

    context "delete postal address" do

      before { @input.arguments = ["jim", "home"] }
      before { @input.options = { :delete => true }}

      it "deletes the postal address" do
        @storage.should_receive(:require_contact).and_return(@contact)
        @service.should_receive(:remove).with(@contact, "home")
        @storage.should_receive(:save_contact)
        @command.execute(@input, @output).should eq true
      end

    end

    context "update postal address" do

      before { @input.arguments = ["jim", "home"] }
      before { @input.options = { :country => "New Country" }}

      it "updates the postal address" do
        @storage.should_receive(:require_contact).and_return(@contact)
        @service.should_receive(:update).with(@contact, "home", {:country => "New Country"})
        @storage.should_receive(:save_contact)
        @command.execute(@input, @output).should eq true
      end

    end


    context "add postal address" do

      before { @input.arguments = ["jim", "newaddress"] }
      before { @input.options = { :street => "123 Swim St" }}

      it "adds the postal address" do
        @storage.should_receive(:require_contact).and_return(@contact)
        @service.should_receive(:add).with(@contact, "newaddress", {:street => "123 Swim St"})
        @storage.should_receive(:save_contact)
        @command.execute(@input, @output).should eq true
      end

    end

  end

end

