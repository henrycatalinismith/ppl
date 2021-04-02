class Ppl::Format::AddressBook::Ages < Ppl::Format::AddressBook

  attr_writer :table
  attr_writer :date

  def initialize(colors={})
    @table = Ppl::Format::Table.new([:id, :age], colors)
    @date  = Date.today
  end

  def process(address_book)
    address_book.contacts.each { |contact| add_row(contact) }
    @table.to_s
  end

  private

  def add_row(contact)
    @table.add_row({
      :id  => sprintf("%s:", contact.id),
      :age => contact.age(@date).to_s,
    })
  end

end

