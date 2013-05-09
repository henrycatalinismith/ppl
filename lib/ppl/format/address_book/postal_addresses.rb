
class Ppl::Format::AddressBook::PostalAddresses < Ppl::Format::AddressBook

  attr_writer :table

  def initialize(colors={})
    @table = Ppl::Format::Table.new([:id, :address_ids], colors)
  end

  def process(address_book)
    address_book.contacts.each { |contact| add_row(contact) }
    @table.to_s
  end

  private

  def add_row(contact)
    @table.add_row({
      :id          => sprintf("%s:", contact.id),
      :address_ids => format_address_ids(contact.postal_addresses),
    })
  end

  def format_address_ids(postal_addresses)
    postal_addresses.map { |pa| pa.id }.join(", ")
  end

end

