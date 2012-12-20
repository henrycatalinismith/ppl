
class Ppl::Format::AddressBook::PostalAddresses < Ppl::Format::AddressBook

  attr_writer :table

  def initialize
    @table = Ppl::Format::Table.new([:id, :email_address])
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
      postal_address = contact.postal_address
    end

    @table.add_row({
      :id             => id,
      :postal_address => postal_address,
    })
  end


end

