
class Ppl::Command::Name < Ppl::Application::Command

  attr_writer :show_format

  def initialize
    @name        = "name"
    @description = "Show or change a contact's name"
    @show_format = Ppl::Format::Contact::Name.new
  end

  def options(parser, options)
    parser.banner = "usage: ppl name <contact> [<name>]"
  end

  def execute(input, output)

    contact_id = input.arguments.shift
    name       = input.arguments.shift

    if contact_id.nil?
      raise Ppl::Error::IncorrectUsage, "No contact specified"
    end

    contact = @storage.require_contact(contact_id)

    if name.nil?
      show_name(contact, output)
    else
      set_name(contact, name.dup)
    end

    return true
  end

  private

  def show_name(contact, output)
    output.line(@show_format.process(contact))
  end

  def set_name(contact, name)
    contact.name = name
    @storage.save_contact(contact)
  end

end

