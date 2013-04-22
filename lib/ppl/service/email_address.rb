
class Ppl::Service::EmailAddress

  attr_writer :storage

  def add(contact, address)
    email_address = Ppl::Entity::EmailAddress.new(address)
    contact.email_addresses << email_address
    @storage.save_contact(contact)
  end

  def update(contact, address, options)
    @storage.save_contact(contact)
  end

  def remove(contact, address)
    contact.email_addresses.select! do |email_address|
      email_address.address != address
    end
    @storage.save_contact(contact)
  end

end

