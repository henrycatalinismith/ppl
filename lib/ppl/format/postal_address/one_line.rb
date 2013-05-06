
class Ppl::Format::PostalAddress::OneLine < Ppl::Format::AddressBook

  def process(postal_address, table)
    table.add_row({
      :address_id   => postal_address.id,
      :address_text => format_address_text(postal_address),
    })
  end

  private

  def format_address_text(postal_address)
    [
      postal_address.street,
      postal_address.locality,
      postal_address.region,
      postal_address.country,
      postal_address.postal_code,
      postal_address.po_box,
    ].compact.join(", ")
  end

end

