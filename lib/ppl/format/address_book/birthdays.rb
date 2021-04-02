class Ppl::Format::AddressBook::Birthdays < Ppl::Format::AddressBook

  attr_writer :table

  def initialize(colors={})
    @table = Ppl::Format::Table.new([:id, :birthday], colors)
  end

  def process(address_book)
    address_book.contacts.each { |contact| add_row(contact) }
    @table.to_s
  end


  private

  def add_row(contact)
    birthday = nil
    if !contact.birthday.nil?
      birthday = contact.birthday.strftime("%Y-%m-%d")
    end
    @table.add_row({
      :id       => sprintf("%s:", contact.id),
      :birthday => birthday,
    })
  end


end

