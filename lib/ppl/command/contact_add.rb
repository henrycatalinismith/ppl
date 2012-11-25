
class Ppl::Command::ContactAdd < Ppl::Application::Command

  def initialize
    @name        = "add"
    @description = "Add a new contact"
  end

  def execute(input, output)
    contact_id   = input.arguments.shift
    contact_name = input.arguments.shift

    if contact_id.nil? || contact_name.nil?
      raise Ppl::Error::IncorrectUsage
    end

    contact = Ppl::Entity::Contact.new
    contact.id = contact_id
    contact.name = contact_name

    @storage.save_contact(contact)
    return true
  end

end

