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
      expect(@command.name).to eq "post"
    end
  end

  describe "#execute" do

    context "show address book" do

      before { @input.arguments = [] }

      it "displays postal address information for the whole address book" do
        expect(@storage).to receive(:load_address_book).and_return(@address_book)
        expect(@address_book_format).to receive(:process).and_return("all the postal addresses")
        expect(@output).to receive(:line).with("all the postal addresses")
        @input.arguments = []
        @command.execute(@input, @output)
      end
    end

    context "show contact" do

      before { @input.arguments = ["jim"] }

      it "shows all of a contact's postal addresses" do
        expect(@storage).to receive(:require_contact).and_return(@contact)
        expect(@contact_format).to receive(:process).and_return("1 Test Road")
        expect(@output).to receive(:line).with("1 Test Road")
        expect(@command.execute(@input, @output)).to eq true
      end

      it "outputs nothing if the contact has no addresses" do
        expect(@storage).to receive(:require_contact).and_return(@contact)
        expect(@contact_format).to receive(:process).and_return("")
        expect(@command.execute(@input, @output)).to eq false
      end

    end

    context "show postal address" do

      before { @input.arguments = ["jim", "home"] }

      it "shows a single postal address" do
        expect(@storage).to receive(:require_contact).and_return(@contact)
        expect(@postal_address_format).to receive(:process).with(@address).and_return("1 Test Road")
        expect(@output).to receive(:line).with("1 Test Road")
        expect(@command.execute(@input, @output)).to eq true
      end

      it "raises an error if there's no such address" do
        @input.arguments[1] = "other"
        expect(@storage).to receive(:require_contact).and_return(@contact)
        expect{expect(@command.execute(@input, @output)).to eq true}.to raise_error(Ppl::Error::PostalAddressNotFound)
      end

    end

    context "delete postal address" do

      before { @input.arguments = ["jim", "home"] }
      before { @input.options = { :delete => true }}

      it "deletes the postal address" do
        expect(@storage).to receive(:require_contact).and_return(@contact)
        expect(@service).to receive(:remove).with(@contact, "home")
        expect(@storage).to receive(:save_contact)
        expect(@command.execute(@input, @output)).to eq true
      end

    end

    context "update postal address" do

      before { @input.arguments = ["jim", "home"] }
      before { @input.options = { :country => "New Country" }}

      it "updates the postal address" do
        expect(@storage).to receive(:require_contact).and_return(@contact)
        expect(@service).to receive(:update).with(@contact, "home", {:country => "New Country"})
        expect(@storage).to receive(:save_contact)
        expect(@command.execute(@input, @output)).to eq true
      end

    end


    context "add postal address" do

      before { @input.arguments = ["jim", "newaddress"] }
      before { @input.options = { :street => "123 Swim St" }}

      it "adds the postal address" do
        expect(@storage).to receive(:require_contact).and_return(@contact)
        expect(@service).to receive(:add).with(@contact, "newaddress", {:street => "123 Swim St"})
        expect(@storage).to receive(:save_contact)
        expect(@command.execute(@input, @output)).to eq true
      end

    end

  end

end

