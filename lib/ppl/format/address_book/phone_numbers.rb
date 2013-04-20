
class Ppl::Format::AddressBook::PhoneNumbers < Ppl::Format::AddressBook

  attr_writer :table

  def initialize(colors={})
    @table = Ppl::Format::Table.new([:id, :phone_numbers], colors)
  end

  def process(address_book)
    address_book.contacts.each { |contact| add_row(contact) }
    @table.to_s
  end


  private

  def add_row(contact)
    @table.add_row({
      :id            => sprintf("%s:", contact.id),
      :phone_numbers => stringify_phone_numbers(contact.phone_numbers)
    })
  end

  def stringify_phone_numbers(phone_numbers)
    phone_numbers.map { |pn| pn.number }.join(", ")
  end

end

