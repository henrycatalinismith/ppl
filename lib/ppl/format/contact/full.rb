
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

    format_organizations(contact)
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
    email_address = choose_first_line_address(contact)
    unless email_address.nil?
      line += " <#{email_address.address}>"
    end
    return line
  end

  def choose_first_line_address(contact)
    preferred = contact.email_addresses.find { |e| e.preferred }
    if preferred.nil?
      contact.email_addresses.first
    else
      preferred
    end
  end

  def vitals(contact)
    vitals = []
    if !contact.birthday.nil?
      vitals.push(format_vital("Birthday", contact.birthday.strftime("%Y-%m-%d")))
    end
    return vitals.join("\n")
  end

  def format_vital(name, value)
    return sprintf("  %-12s %s", name, value)
  end

  def format_organizations(contact)
    push_list("Organizations", contact.organizations)
  end

  def format_email_addresses(contact)
    push_list("Email Addresses", contact.email_addresses, :address)
  end

  def format_phone_numbers(contact)
    unless contact.phone_numbers.empty?
      @lines << ""
      @lines << "Phone Numbers"
      contact.phone_numbers.each do |pn|
        @lines << "  #{pn.number}"
      end
    end
  end

  def format_postal_addresses(contact)
    if !contact.postal_address.nil?
      push_list(
        "Postal Address",
        @postal_address_format.process(contact.postal_address)
      )
    end
  end

  def format_urls(contact)
    push_list("URLs", contact.urls)
  end

  def push_list(label, list, property = nil)
    return if list.empty?
    @lines.push("")
    @lines.push("#{label}:")
    if list.kind_of?(Array)
      list.each do |item|
        string = property.nil? ? item : item.send(property)
        @lines << "  #{string}"
      end
    else
      @lines.push("  #{list}")
    end
  end

end

