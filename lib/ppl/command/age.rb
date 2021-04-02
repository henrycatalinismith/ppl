class Ppl::Command::Age < Ppl::Application::Command

  name        "age"
  description "List or show contacts's ages"

  attr_writer :list_format
  attr_writer :show_format

  def options(parser, options)
    parser.banner = "usage: ppl age"
  end

  def execute(input, output)
    action = determine_action(input)
    send(action, input, output)
  end


  private

  def determine_action(input)
    if input.arguments[0].nil?
      :list_ages
    else
      :show_age
    end
  end

  def list_ages(input, output)
    address_book = @storage.load_address_book
    formatted    = @list_format.process(address_book)
    output.line(formatted)
    return true
  end

  def show_age(input, output)
    contact   = @storage.require_contact(input.arguments.first)
    formatted = @show_format.process(contact)
    output.line(formatted)
    return true
  end

end

