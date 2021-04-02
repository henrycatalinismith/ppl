class Ppl::Format::Contact::EmailAddresses < Ppl::Format::Contact

  attr_writer :table

  def initialize(colors={})
    @table = Ppl::Format::Table.new([:star, :email_addresses], colors)
  end

  def process(contact)
    contact.email_addresses.each do |email_address|
      @table.add_row({
        :star            => email_address.preferred ? "*" : " ",
        :email_addresses => email_address.address,
      })
    end
    @table.to_s
  end

end

