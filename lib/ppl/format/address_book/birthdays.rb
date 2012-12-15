
class Ppl::Format::AddressBook::Birthdays < Ppl::Format::AddressBook

  attr_writer :table

  def initialize
    @table = Ppl::Format::Table.new([:id, :birthday])
  end

  def process(address_book)
    address_book.each { |contact| add_row(contact) }
    @table.to_s
  end


  private

  def add_row(contact)
    id       = sprintf("%s:", contact.id)
    birthday = nil

    if !contact.birthday.nil?
      birthday = contact.birthday.strftime("%Y-%m-%d")
    end

    @table.add_row({
      :id       => id,
      :birthday => birthday,
    })
  end


end

