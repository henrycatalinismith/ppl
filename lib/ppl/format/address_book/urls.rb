
class Ppl::Format::AddressBook::Urls < Ppl::Format::AddressBook

  attr_writer :table

  def initialize
    @table = Ppl::Format::Table.new([:id, :urls])
  end

  def process(address_book)
    address_book.each { |contact| add_row(contact) }
    @table.to_s
  end


  private

  def add_row(contact)
    id   = sprintf("%s:", contact.id)
    urls = nil

    if !contact.urls.empty?
      urls = contact.urls.join(", ")
    end

    @table.add_row({
      :id   => id,
      :urls => urls,
    })
  end


end

