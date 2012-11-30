
class Ppl::Command::SetOrganization < Ppl::Application::Command

  def initialize
    @name        = "org"
    @description = "Change a contact's organization"
  end

  def options(parser, options)
    parser.banner = "usage: ppl org <contact> <organization>"
  end

  def execute(input, output)

    contact_id   = input.arguments.shift
    organization = input.arguments.shift

    if contact_id.nil?
      raise Ppl::Error::IncorrectUsage, "No contact specified"
    end

    if organization.nil?
      raise Ppl::Error::IncorrectUsage, "No date specified"
    end

    contact = @storage.require_contact(contact_id)
    contact.organization = organization

    storage.save_contact(contact)

    return true
  end

end

