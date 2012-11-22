
class Ppl::Command::ContactRename < Ppl::Application::Command

  def initialize
    @name        = "mv"
    @description = "Rename a contact"
  end

  def execute(input, output)
    old_id  = input.arguments.shift
    new_id  = input.arguments.shift
    contact = @storage.require_contact(old_id)

    @storage.delete_contact(contact)

    contact.id = new_id
    @storage.save_contact(contact)

    return true
  end

end

