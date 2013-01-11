
class Ppl::Format::AddressBook::EmailAddresses < Ppl::Format::AddressBook

  attr_writer :table

  def initialize
    @table = Ppl::Format::Table.new([:contact_id, :email_addresses])
  end

  def process(address_book)
    address_book.contacts.each { |contact| add_row(contact) }
    @table.to_s
  end


  private

  def add_row(contact)
    @table.add_row({
      :contact_id      => sprintf("%s:", contact.id),
      :email_addresses => contact.email_addresses.join(", "),
    })
  end


end

