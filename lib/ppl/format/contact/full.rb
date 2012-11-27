
class Ppl::Format::Contact::Full < Ppl::Format::Contact

  def process(contact)
    lines = []

    first_line = first_line(contact)
    if first_line != ""
      lines.push(first_line)
    end

    return lines.join("\n")
  end

  private

  def first_line(contact)
    line = ""

    if !contact.name.nil?
      line += contact.name
    end

    if !contact.email_address.nil?
      line += " <#{contact.email_address}>"
    end

    return line
  end

end

