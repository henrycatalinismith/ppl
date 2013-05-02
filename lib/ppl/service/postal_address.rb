
class Ppl::Service::PostalAddress

  def add(contact, options)
    address = Ppl::Entity::PostalAddress.new
    address.country = options[:country]
    address.locality = options[:locality]
    address.po_box = options[:po_box]
    address.postal_code = options[:postal_code]
    address.region = options[:region]
    address.street = options[:street]
    contact.postal_addresses << address
  end

end

