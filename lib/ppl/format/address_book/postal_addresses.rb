
class Ppl::Format::AddressBook::PostalAddresses < Ppl::Format::AddressBook

  attr_writer :table

  def initialize(colors={})
    @table = Ppl::Format::Table.new([:id, :postal_address], colors)
  end

  def process(address_book)
    address_book.contacts.each { |contact| add_row(contact) }
    @table.to_s
  end


  private

  def add_row(contact)
    postal_address = nil
    if !contact.postal_address.nil?
      postal_address = format_postal_address(contact.postal_address)
    end
    @table.add_row({
      :id             => sprintf("%s:", contact.id),
      :postal_address => postal_address,
    })
  end

  def format_postal_address(postal_address)
    pieces = [
      postal_address.street,
      postal_address.locality,
      postal_address.region,
      postal_address.country,
      postal_address.postal_code,
      postal_address.po_box,
    ].select { |property| property != "" && !property.nil? }
    pieces.join(", ")
  end

end

