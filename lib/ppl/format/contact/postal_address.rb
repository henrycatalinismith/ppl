
class Ppl::Format::Contact::PostalAddress < Ppl::Format::Contact

  attr_writer :table

  def initialize
    @table = Ppl::Format::Table.new([:label, :value])
  end

  def process(contact)
    address = contact.postal_address

    {
      :street      => "Street",
      :postal_code => "Postal Code",
      :po_box      => "PO box",
      :locality    => "Locality",
      :region      => "Region",
      :country     => "Country",
    }.each do |property, name|
      value = address.send(property)
      next if value.nil? || value == ""
      @table.add_row({
        :label => sprintf("%s:", name),
        :value => address.send(property)
      })
    end

    return @table.to_s
  end

end

