
class Ppl::Command::Org < Ppl::Application::Command

  attr_writer :format

  def initialize
    @name        = "org"
    @description = "Show or change a contact's organization"
    @format      = Ppl::Format::Contact::Organization.new
  end

  def options(parser, options)
    parser.banner = "usage: ppl org <contact> [<organization>]"
  end

  def execute(input, output)

    contact_id   = input.arguments.shift
    organization = input.arguments.shift

    if contact_id.nil?
      raise Ppl::Error::IncorrectUsage, "No contact specified"
    end

    contact = @storage.require_contact(contact_id)

    if organization.nil?
      show_organization(contact, output)
    else
      set_organization(contact, organization)
    end

    return true
  end

  private
  
  def show_organization(contact, output)
    output.line(@format.process(contact))
  end

  def set_organization(contact, organization)
    contact.organization = organization
    @storage.save_contact(contact)
  end

end

