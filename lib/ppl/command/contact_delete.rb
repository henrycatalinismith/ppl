
class Ppl::Command::ContactDelete < Ppl::Application::Command

  def initialize
    @name        = "rm"
    @description = "Delete a contact"
  end

  def execute(input, output)
    contact_id = input.arguments.first
    contact    = @storage.require_contact(contact_id)
    @storage.delete_contact(contact)
  end

end

