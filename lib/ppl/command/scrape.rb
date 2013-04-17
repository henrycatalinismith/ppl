
require "mail"

class Ppl::Command::Scrape < Ppl::Application::Command

  name        "scrape"
  description "Scrape contact details from stdin"

  attr_writer :format

  def options(parser, options)
    parser.banner = "usage: ppl scrape [<options>]"
  end

  def execute(input, output)
    email = Mail.new(input.stdin)
    contact = Ppl::Entity::Contact.new
    contact.name = email[:from].tree.addresses.first.display_name
    contact.email_addresses << email[:from].tree.addresses.first.address
    @storage.save_contact(contact)
    return true
  end

end

