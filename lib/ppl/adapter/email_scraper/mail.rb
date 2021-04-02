require "mail"

class Ppl::Adapter::EmailScraper::Mail

  attr_writer :storage_adapter

  def scrape_contacts(message)
    email = Mail.new(message)
    contacts = []

    sender = scrape_sender(email)
    unless sender.nil?
      contacts << sender
    end

    contacts
  end

  private

  def scrape_sender(email)
    from = email[:from]
    unless from.nil?
      sender = Ppl::Entity::Contact.new
      sender.name = Ppl::Entity::Name.new
      display_name = from.address_list.addresses.first.display_name
      sender.name.full = Mail::Encodings.value_decode(display_name) unless display_name.nil?
      sender.email_addresses << Ppl::Entity::EmailAddress.new(from.address_list.addresses.first.address)
      sender.id = generate_contact_id(sender)
      sender.name.full = sender.id if display_name.nil?
      sender
    end
  end

  def generate_contact_id(contact)
    if !contact.name.full.nil?
      generate_contact_id_from_name(contact.name)
    elsif !contact.email_addresses.empty?
      contact.email_addresses.first.address
    end
  end

  def generate_contact_id_from_name(name)
    name = name.full.downcase.tr(" ", "_")
    base = name
    suffix = 0
    until @storage_adapter.load_contact(name).nil?
      suffix += 1
      name = "#{base}_#{suffix}"
    end
    name
  end

end

