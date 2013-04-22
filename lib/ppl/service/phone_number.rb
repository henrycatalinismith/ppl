
class Ppl::Service::PhoneNumber

  attr_writer :storage

  def add(contact, number)
    phone_number = Ppl::Entity::PhoneNumber.new(number)
    contact.phone_numbers << phone_number
    @storage.save_contact(contact)
  end

  def remove(contact, number)
    contact.phone_numbers.select! do |phone_number|
      phone_number.number != number
    end
    @storage.save_contact(contact)
  end

end

