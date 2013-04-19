
require "mail"

class Ppl::Adapter::EmailScraper::Mail

  def scrape_contacts(email)
    email = Mail.new(email)
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
      sender.name = from.tree.addresses.first.display_name
      sender.email_addresses << from.tree.addresses.first.address
      sender.id = generate_contact_id(sender)
      sender
    end
  end

  def generate_contact_id(contact)
    if !contact.name.nil?
      contact.name.downcase.tr(" ", "_")
    elsif !contact.email_addresses.empty?
      contact.email_addresses.first
    end
  end

end

