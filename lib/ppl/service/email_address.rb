
class Ppl::Service::EmailAddress

  attr_writer :storage

  def add(contact, address)
    email_address = Ppl::Entity::EmailAddress.new(address)
    contact.email_addresses << email_address
    @storage.save_contact(contact)
  end

  def update(contact, address, options)
    email_address = contact.email_addresses.find { |e| e.address == address }
    if options[:preferred] == true
      contact.email_addresses.each { |e| e.preferred = (e.address == address) }
    elsif options[:preferred] == false
      email_address.preferred = false
    end
    @storage.save_contact(contact)
  end

  def remove(contact, address)
    contact.email_addresses.select! do |email_address|
      email_address.address != address
    end
    @storage.save_contact(contact)
  end

end

