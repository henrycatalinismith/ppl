
class Ppl::Format::AddressBook::EmailAddresses < Ppl::Format::AddressBook

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
    id            = sprintf("%s:", contact.id)
    email_address = nil

    if !contact.email_address.nil?
      email_address = contact.email_address
    end

    @table.add_row({
      :id            => id,
      :email_address => email_address,
    })
  end


end

