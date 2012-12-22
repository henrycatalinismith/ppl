
class Ppl::Format::AddressBook::OneLine < Ppl::Format::AddressBook

  attr_writer :table

  def initialize
    @table = Ppl::Format::Table.new([:id, :name, :email])
  end

  def process(address_book)
    address_book.each { |contact| add_row(contact) }
    @table.to_s
  end

  private

  def add_row(contact)
    id    = sprintf("%s:", contact.id)
    name  = contact.name
    email = nil

    if !contact.email_addresses.empty?
      email = sprintf("<%s>", contact.email_addresses.first)
    end

    @table.add_row({
      :id    => id,
      :name  => name,
      :email => email,
    })
  end

end

