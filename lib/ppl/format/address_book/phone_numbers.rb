
class Ppl::Format::AddressBook::PhoneNumbers < Ppl::Format::AddressBook

  attr_writer :table

  def initialize
    @table = Ppl::Format::Table.new([:id, :phone_number])
  end

  def process(address_book)
    address_book.contacts.each { |contact| add_row(contact) }
    @table.to_s
  end


  private

  def add_row(contact)
    contact_id   = sprintf("%s:", contact.id)
    phone_number = nil

    if !contact.phone_number.nil?
      phone_number = contact.phone_number
    end

    @table.add_row({
      :id           => contact_id,
      :phone_number => phone_number,
    })
  end


end

