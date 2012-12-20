
describe Ppl::Format::Contact::PostalAddress do

  before(:each) do
    @format  = Ppl::Format::Contact::PostalAddress.new
    @contact = Ppl::Entity::Contact.new
    @address = Ppl::Entity::PostalAddress.new
    @table   = double(Ppl::Format::Table)
    @contact.postal_address = @address
    @format.table = @table
  end

  describe "#process" do

    it "should return the contact's street address if it is set" do
      @address.street = "1 Test Road"
      @table.should_receive(:add_row).with({
        :label => "Street:",
        :value => "1 Test Road",
      })
      @format.process(@contact)
    end

  end

end

