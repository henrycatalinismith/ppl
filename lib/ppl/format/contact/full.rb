
class Ppl::Format::Contact::Full < Ppl::Format::Contact

  def process(contact)
    lines = []

    first_line = first_line(contact)
    if first_line != ""
      lines.push(first_line)
    end

    vitals = vitals(contact)
    if vitals != ""
      lines.push("")
      lines.push(vitals)
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

  def vitals(contact)
    vitals = []
    if !contact.birthday.nil?
      line = sprintf("  %-12s %s", "Birthday", contact.birthday.strftime("%Y-%m-%d"))
      vitals.push(line)
    end
    return vitals.join("\n")
  end

end

