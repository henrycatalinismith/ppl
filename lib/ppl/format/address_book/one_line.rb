
class Ppl::Format::AddressBook::OneLine < Ppl::Format::AddressBook

  def process(address_book)
    lines = []

    address_book.each do |contact|
      lines.push(format_contact(contact))
    end

    return lines.join("\n")
  end

  private

  def format_contact(contact)
    line = ""

    line = sprintf("%s:", contact.id)

    if !contact.name.nil?
      line += contact.name
    end

    if !contact.email_address.nil?
      line += " <#{contact.email_address}>"
    end

    return line
  end

end

