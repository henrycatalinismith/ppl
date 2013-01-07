
class Ppl::Command::Attribute < Ppl::Application::Command

  attr_writer :list_format
  attr_writer :show_format

  def execute(input, output)
    action = determine_action(input)
    send(action, input, output)
  end


  private

  def determine_action(input)
    if input.arguments[0].nil?
      :list_attribute
    elsif input.arguments[1].nil?
      :show_attribute
    end
  end

  def list_attribute(input, output)
    address_book = @storage.load_address_book
    output.line(@list_format.process(address_book))
    true
  end

  def show_attribute(input, output)
    contact = @storage.require_contact(input.arguments[0])
    output.line(@show_format.process(contact))
    true
  end

  def add_attribute(input, output)
  end

  def remove_attribute(input, output)
  end

end

