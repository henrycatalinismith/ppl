
class Ppl::Format::AddressBook::Names < Ppl::Format::AddressBook

  attr_writer :table

  def initialize(colors={})
    @table = Ppl::Format::Table.new([:id, :name], colors)
  end

  def process(address_book)
    address_book.contacts.each { |contact| add_row(contact) }
    @table.to_s
  end


  private

  def add_row(contact)
    id       = sprintf("%s:", contact.id)
    name = nil

    if !contact.name.nil?
      name = contact.name
    end

    @table.add_row({
      :id   => id,
      :name => name,
    })
  end


end

