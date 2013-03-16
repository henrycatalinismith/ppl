
class Ppl::Command::Ls < Ppl::Application::Command

  name        "ls"
  description "List all contacts"

  attr_writer :format

  def options(parser, options)
    parser.banner = "usage: ppl ls"
  end

  def execute(input, output)
    address_book = @storage.load_address_book
    formatted    = @format.process(address_book)
    output.line(formatted)
    return true
  end

end

