class Ppl::Format::PostalAddress::OneLine < Ppl::Format::AddressBook

  def process(postal_address, table)
    table.add_row({
      :star         => format_star(postal_address),
      :address_id   => postal_address.id,
      :address_text => format_address_text(postal_address),
    })
  end

  private

  def format_star(postal_address)
    postal_address.preferred ? "*" : " "
  end

  def format_address_text(postal_address)
    [
      postal_address.street,
      postal_address.locality,
      postal_address.region,
      postal_address.country,
      postal_address.postal_code,
      postal_address.po_box,
    ].compact.reject(&:empty?).join(", ")
  end

end

