
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
    require_address(contact, address_id)
    contact.postal_addresses.reject! { |pa| pa.id == address_id }
  end

  private

  def require_address(contact, address_id)
    address = contact.postal_addresses.find { |p| p.id == address_id }
    if address.nil?
      raise Ppl::Error::PostalAddressNotFound, address_id
    end
    address
  end

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

