
class Ppl::Format::AddressBook::OneLine < Ppl::Format::AddressBook

  def process(address_book)
    lines = []

    column_widths = precompute_column_widths(address_book)

    address_book.each do |contact|
      lines.push(format_contact(contact, column_widths))
    end

    return lines.join("\n")
  end

  private

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

