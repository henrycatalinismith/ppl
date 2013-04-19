
class Ppl::Format::AddressBook::Nicknames < Ppl::Format::AddressBook

  attr_writer :table

  def initialize(colors={})
    @table = Ppl::Format::Table.new([:id, :nicknames], colors)
  end

  def process(address_book)
    address_book.contacts.each { |contact| add_row(contact) }
    @table.to_s
  end

  def disable_colors!
    @table.disable_colors!
  end

  private

  def add_row(contact)
    @table.add_row({
      :id        => sprintf("%s:", contact.id),
      :nicknames => contact.nicknames.join(", "),
    })
  end


end

