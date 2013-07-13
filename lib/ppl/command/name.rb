
class Ppl::Command::Name < Ppl::Application::Command

  name        "name"
  description "List, show or change names"

  attr_writer :show_format
  attr_writer :list_format
  attr_writer :name_service

  def options(parser, options)
    parser.banner = "usage: ppl name <contact> [<name>]"
    parser.on("-f", "--family <family-name(s)>") do |family|
      options[:family] = family
    end
    parser.on("-g", "--given <given-name(s)>") do |given|
      options[:given] = given
    end
    parser.on("-m", "--middle <middle-name(s)>") do |middle|
      options[:middle] = middle
    end
    parser.on("-p", "--prefix <prefix>") do |prefix|
      options[:prefix] = prefix
    end
    parser.on("-s", "--suffix <suffix>") do |suffix|
      options[:suffix] = suffix
    end
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
    options = input.options.dup
    if !input.arguments[1].nil?
      options[:full] = input.arguments[1].dup
    end
    @name_service.update(contact.name, options)
    @storage.save_contact(contact)
  end

end

