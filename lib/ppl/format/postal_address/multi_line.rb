class Ppl::Format::PostalAddress::MultiLine < Ppl::Format::AddressBook

  def process(postal_address)
    lines = []
    lines << postal_address.street
    lines << postal_address.locality
    lines << postal_address.region
    lines << postal_address.country
    lines << postal_address.po_box
    lines << postal_address.postal_code
    lines.compact.reject(&:empty?).join "\n"
  end

end

