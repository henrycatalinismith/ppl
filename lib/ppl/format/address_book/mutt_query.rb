
class Ppl::Format::AddressBook::MuttQuery < Ppl::Format::AddressBook

  attr_writer :table

  def initialize
    @table = Ppl::Format::Table.new([:email, :name])
    @table.separator = Ppl::Format::Table::SEPARATOR_TABS
  end

  def process(address_book)
    address_book.contacts.each { |contact| add_row(contact) }
    @table.to_s
  end


  private

  def add_row(contact)
    name = nil
    if !contact.name.nil?
      name = contact.name
    end

    @table.add_row({
      :email => contact.email_addresses.first,
      :name  => name,
    })
  end


end

