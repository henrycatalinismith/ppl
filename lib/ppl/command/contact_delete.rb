
class Ppl::Command::ContactDelete < Ppl::Application::Command

  def initialize
    @name        = "rm"
    @description = "Delete a contact"
  end

  def execute(input, output)
    contact_id = input.arguments.first
    contact    = @storage.load_contact(contact_id)

    if contact.nil?
      raise Ppl::Error::ContactNotFound
    end

    @storage.delete_contact(contact)
  end

end

