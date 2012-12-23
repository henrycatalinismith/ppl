
class Ppl::Command::Name < Ppl::Application::Command

  name        "name"
  description "List, show or change names"

  attr_writer :show_format
  attr_writer :list_format

  def initialize
    @show_format = Ppl::Format::Contact::Name.new
    @list_format = Ppl::Format::AddressBook::Names.new
  end

  def options(parser, options)
    parser.banner = "usage: ppl name <contact> [<name>]"
  end

  def execute(input, output)
    action = determine_action(input)
    send(action, input, output)
  end

  private

  def determine_action(input)
    if input.arguments[0].nil?
      :list_names
    elsif input.arguments[1].nil?
      :show_name
    else
      :set_name
    end
  end

  def list_names(input, output)
    address_book = @storage.load_address_book
    name_list    = @list_format.process(address_book)
    output.line(name_list)
  end

  def show_name(input, output)
    contact = @storage.require_contact(input.arguments[0])
    name    = @show_format.process(contact)
    if name != ""
      output.line(name)
      true
    else
      false
    end
  end

  def set_name(input, output)
    contact = @storage.require_contact(input.arguments[0])
    contact.name = input.arguments[1].dup
    @storage.save_contact(contact)
  end

end

