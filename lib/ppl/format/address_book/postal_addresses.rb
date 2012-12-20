
class Ppl::Format::AddressBook::PostalAddresses < Ppl::Format::AddressBook

  attr_writer :table

  def initialize
    @table = Ppl::Format::Table.new([:id, :postal_address])
  end

  def process(address_book)
    address_book.each { |contact| add_row(contact) }
    @table.to_s
  end


  private

  def add_row(contact)
    id             = sprintf("%s:", contact.id)
    postal_address = nil

    if !contact.postal_address.nil?
      pieces = [
        contact.postal_address.street,
        contact.postal_address.locality,
        contact.postal_address.region,
        contact.postal_address.country,
        contact.postal_address.postal_code,
        contact.postal_address.po_box,
      ].select { |property| property != "" && !property.nil? }
      postal_address = pieces.join(", ")
    end

    @table.add_row({
      :id             => id,
      :postal_address => postal_address,
    })
  end


end

