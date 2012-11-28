
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
      lines.push("")
      lines.push("")
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
      vitals.push(format_vital("Birthday", contact.birthday.strftime("%Y-%m-%d")))
    end
    if !contact.phone_number.nil?
      vitals.push(format_vital("Telephone", contact.phone_number))
    end
    return vitals.join("\n")
  end

  def format_vital(name, value)
    return sprintf("  %-12s %s", name, value)
  end

end

