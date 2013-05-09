
class Ppl::Format::Contact::PostalAddresses < Ppl::Format::Contact

  attr_writer :table
  attr_writer :postal_address_format

  def initialize(colors={})
    @table = Ppl::Format::Table.new([:star, :address_id, :address_text], colors)
    @postal_address_format = Ppl::Format::PostalAddress::OneLine.new
  end

  def process(contact)
    contact.postal_addresses.each do |postal_address|
      format_postal_address(postal_address)
    end
    @table.to_s
  end

  private

  def format_postal_address(postal_address)
    @postal_address_format.process(postal_address, @table)
  end

end

