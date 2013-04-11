
class Ppl::Format::AddressBook::MuttQuery < Ppl::Format::AddressBook

  attr_writer :table

  def initialize
    @table = Ppl::Format::Table.new([:email, :name])
    @table.separator = Ppl::Format::Table::SEPARATOR_TABS
  end

  def process(address_book)
    address_book.contacts.each { |contact| add_contact(contact) }
    @table.to_s
  end

  private

  def add_contact(contact)
    contact.email_addresses.each do |email_address|
      add_email_address(email_address, contact.name)
    end
  end

  def add_email_address(email_address, name)
    @table.add_row({
      :email => email_address,
      :name  => name,
    })
  end

end

