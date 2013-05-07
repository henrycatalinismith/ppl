
class Ppl::Service::PostalAddress

  def add(contact, address_id, options)
    address = Ppl::Entity::PostalAddress.new
    address.id = address_id
    update_postal_address(address, options)
    contact.postal_addresses << address
  end

  def update(contact, address_id, options)
    address = contact.postal_addresses.find { |p| p.id == address_id }
    update_postal_address(address, options)
  end

  def remove(contact, address_id)
  end

  private

  def update_postal_address(address, options)
    [
      :country,
      :locality,
      :po_box,
      :postal_code,
      :region,
      :street,
    ].each do |property|
      unless options[property].nil?
        address.send("#{property.to_s}=", options[property])
      end
    end
  end

end

