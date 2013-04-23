
class Ppl::Service::PhoneNumber

  attr_writer :storage

  def add(contact, number, options)
    phone_number = Ppl::Entity::PhoneNumber.new(number)
    contact.phone_numbers << phone_number
    update_phone_number(contact, phone_number, options)
    @storage.save_contact(contact)
  end

  def update(contact, number, options)
    matching_numbers = contact.phone_numbers.select { |p| p.number == number }
    matching_numbers.each { |mn| update_phone_number(contact, mn, options) }
    @storage.save_contact(contact)
  end

  def remove(contact, number)
    contact.phone_numbers.select! do |phone_number|
      phone_number.number != number
    end
    @storage.save_contact(contact)
  end

  private

  def update_phone_number(contact, phone_number, options)
    if options[:type]
      phone_number.type = options[:type]
    end
    if options[:preferred] == true
      contact.phone_numbers.each { |p| p.preferred = (p.number == phone_number.number) }
    elsif options[:preferred] == false
      phone_number.preferred = false
    end
  end

end

