
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

    if !contact.email_address.nil?
      email = sprintf("<%s>", contact.email_address)
    end

    @table.add_row({
      :id    => id,
      :name  => name,
      :email => email,
    })
  end

  def precompute_column_widths(address_book)
    widths = {
      :id    => 0,
      :name  => 0,
      :email => 0,
    }

    address_book.each do |contact|
      if !contact.id.nil? && contact.id.length > widths[:id]
        widths[:id] = contact.id.length
      end
      if !contact.name.nil? && contact.name.length > widths[:name]
        widths[:name] = contact.name.length
      end
      if !contact.email_address.nil? && contact.email_address.length > widths[:email]
        widths[:email] = contact.email_address.length
      end
    end

    return widths
  end

  def format_contact(contact, column_widths)
    line = ""

    id    = ""
    name  = ""
    email = ""

    id = "#{contact.id}:"

    line = sprintf("%-#{column_widths[:id]}s", "#{contact.id}:")

    if !contact.name.nil?
      name = contact.name
    end

    if !contact.email_address.nil?
      email = "<#{contact.email_address}>"
    end

    line = [
      sprintf("%-#{column_widths[:id] + 1}s", id),
      sprintf("%-#{column_widths[:name]}s", name),
      sprintf("%-#{column_widths[:email]}s", email),
    ].join(" ")

    return line
  end

end

