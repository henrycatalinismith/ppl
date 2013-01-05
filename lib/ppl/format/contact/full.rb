
class Ppl::Format::Contact::Full < Ppl::Format::Contact

  attr_writer :postal_address_format

  def initialize
    @postal_address_format = Ppl::Format::PostalAddress::OneLine.new
  end

  def process(contact)
    @lines = []

    first_line = first_line(contact)
    if first_line != ""
      @lines.push(first_line)
    end

    vitals = vitals(contact)
    if vitals != ""
      @lines.push("")
      @lines.push(vitals)
    end

    format_email_addresses(contact)
    format_phone_numbers(contact)
    format_postal_addresses(contact)
    format_urls(contact)

    return @lines.join("\n")
  end

  private

  def first_line(contact)
    line = ""
    if !contact.name.nil?
      line += contact.name
    end
    if !contact.email_addresses.empty?
      line += " <#{contact.email_addresses.first}>"
    end
    return line
  end

  def vitals(contact)
    vitals = []
    if !contact.birthday.nil?
      vitals.push(format_vital("Birthday", contact.birthday.strftime("%Y-%m-%d")))
    end
    if !contact.organization.nil?
      vitals.push(format_vital("Organization", contact.organization))
    end
    return vitals.join("\n")
  end

  def format_vital(name, value)
    return sprintf("  %-12s %s", name, value)
  end

  def format_email_addresses(contact)
    if !contact.email_addresses.empty?
      @lines.push("")
      @lines.push("Email Addresses:")
      contact.email_addresses.each { |email_address| @lines.push("  " + email_address) }
    end
  end

  def format_phone_numbers(contact)
    if !contact.phone_number.nil?
      @lines.push("")
      @lines.push("Phone Numbers:")
      @lines.push("  #{contact.phone_number}")
    end
  end

  def format_postal_addresses(contact)
    if !contact.postal_address.nil?
      @lines.push("")
      @lines.push("Postal Address:")
      @lines.push("  " + @postal_address_format.process(contact.postal_address))
    end
  end

  def format_urls(contact)
    if !contact.urls.empty?
      @lines.push("")
      @lines.push("URLs:")
      contact.urls.each { |url| @lines.push("  " + url) }
    end
  end

end

