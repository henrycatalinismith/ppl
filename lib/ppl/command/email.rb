
class Ppl::Command::Email < Ppl::Command::Attribute

  name        "email"
  description "Show or change a contact's email address"

  def initialize
    @attribute = :email_addresses
  end

  def options(parser, options)
    parser.banner = "usage: ppl email <contact> [<email-address>]"
    parser.on("-d", "--delete", "delete email address") do
      options[:delete] = true
    end
  end

  def add_attribute(input, output)
    contact = @storage.require_contact(input.arguments.shift)
    if new_email_address?(contact, input.arguments[0])
      add_new_email_address(contact, input)
    end
    @storage.save_contact(contact)
    true
  end

  def remove_attribute(input, output)
    contact = @storage.require_contact(input.arguments[0])
    contact.email_addresses.select! { |ea| ea.address != input.arguments[1] }
    @storage.save_contact(contact)
  end

  private

  def new_email_address?(contact, input_address)
    matching_addresses = contact.email_addresses.select do |em|
      em.address == input_address
    end
    matching_addresses.length < 1
  end

  def add_new_email_address(contact, input)
    email_address = Ppl::Entity::EmailAddress.new
    email_address.address = input.arguments[0]
    contact.email_addresses << email_address
  end

end

