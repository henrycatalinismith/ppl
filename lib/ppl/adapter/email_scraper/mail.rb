
require "mail"

class Ppl::Adapter::EmailScraper::Mail

  def scrape_contacts(email)
    email = Mail.new(email)
    contacts = []

    from = email[:from]
    unless from.nil?
      sender = Ppl::Entity::Contact.new
      sender.name = from.tree.addresses.first.display_name
      sender.email_addresses << from.tree.addresses.first.address
      contacts << sender
    end

    contacts
  end

end

