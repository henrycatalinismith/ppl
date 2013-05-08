
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

  def move(contact, address_id, new_address_id)
    address = require_address(contact, address_id)
    id_okay = contact.postal_addresses.select { |pa| pa.id == new_address_id }.empty?
    if id_okay
      address.id = new_address_id
    else
      raise "Address '#{new_address_id}' is already in use"
    end
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

