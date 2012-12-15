
class Ppl::Command::Mv < Ppl::Application::Command

  def initialize
    @name        = "mv"
    @description = "Rename a contact"
  end

  def options(parser, options)
    parser.banner = "usage: ppl mv <contact> <new ID>"
  end

  def execute(input, output)
    old_id  = input.arguments.shift
    new_id  = input.arguments.shift

    if old_id.nil?
      raise Ppl::Error::IncorrectUsage, "No contact specified"
    end

    if new_id.nil?
      raise Ppl::Error::IncorrectUsage, "No new ID specified"
    end

    old_contact = @storage.require_contact(old_id)
    new_contact = @storage.load_contact(new_id)

    if !new_contact.nil?
      output.error("There is already a contact with ID '#{new_id}'")
      return false
    end

    @storage.delete_contact(old_contact)

    old_contact.id = new_id
    @storage.save_contact(old_contact)

    return true
  end

end

