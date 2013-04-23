
class Ppl::Format::AddressBook::OneLine < Ppl::Format::AddressBook

  attr_writer :table

  def initialize(colors={})
    @table = Ppl::Format::Table.new([:id, :name, :email], colors)
  end

  def process(address_book)
    address_book.contacts.each { |contact| add_row(contact) }
    @table.to_s
  end

  private

  def add_row(contact)
    id    = sprintf("%s:", contact.id)
    name  = contact.name
    email = nil

    if !contact.email_addresses.empty?
      email = sprintf("<%s>", choose_email_address(contact).address)
    end

    @table.add_row({
      :id    => id,
      :name  => name,
      :email => email,
    })
  end

  def choose_email_address(contact)
    preferred = contact.email_addresses.find { |e| e.preferred }
    if preferred.nil?
      contact.email_addresses.first
    else
      preferred
    end
  end

end

