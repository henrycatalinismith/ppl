
class Ppl::Format::PostalAddress::OneLine < Ppl::Format::AddressBook

  def process(postal_address)
    pieces = []

    pieces.push(postal_address.street)      unless postal_address.street.nil?
    pieces.push(postal_address.locality)    unless postal_address.locality.nil?
    pieces.push(postal_address.region)      unless postal_address.region.nil?
    pieces.push(postal_address.country)     unless postal_address.country.nil?
    pieces.push(postal_address.postal_code) unless postal_address.postal_code.nil?
    pieces.push(postal_address.po_box)      unless postal_address.po_box.nil?

    pieces.join(", ")
  end

end

