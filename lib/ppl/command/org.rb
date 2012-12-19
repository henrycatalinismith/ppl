
class Ppl::Command::Org < Ppl::Application::Command

  attr_writer :show_format
  attr_writer :list_format

  def initialize
    @name        = "org"
    @description = "List, show or change organizations"
    @show_format = Ppl::Format::Contact::Organization.new
    @list_format = Ppl::Format::AddressBook::Organizations.new
  end

  def options(parser, options)
    parser.banner = "usage: ppl org <contact> [<organization>]"
  end

  def execute(input, output)
    action = determine_action(input)
    send(action, input, output)
  end


  private

  def determine_action(input)
    if input.arguments[0].nil?
      :list_organizations
    elsif input.arguments[1].nil?
      :show_organization
    else
      :set_organization
    end
  end

  def list_organizations(input, output)
    address_book = @storage.load_address_book
    org_list     = @list_format.process(address_book)
    output.line(org_list)
  end

  def show_organization(input, output)
    contact      = @storage.require_contact(input.arguments[0])
    organization = @show_format.process(contact)
    if organization != ""
      output.line(organization)
      true
    else
      false
    end
  end

  def set_organization(input, output)
    contact = @storage.require_contact(input.arguments[0])
    contact.organization = input.arguments[1].dup
    @storage.save_contact(contact)
  end

end

