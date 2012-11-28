
class Ppl::Command::ContactList < Ppl::Application::Command

  attr_writer :format

  def initialize
    @name        = "ls"
    @description = "List all contacts"

    @format = Ppl::Format::AddressBook::OneLine.new
  end

  def options(parser, options)
  end

  def execute(input, output)

    address_book = @storage.load_address_book

    formatted = @format.process(address_book)

    output.line(formatted)
    return true
  end

end

