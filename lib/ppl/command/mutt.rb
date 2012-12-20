
class Ppl::Command::Mutt < Ppl::Application::Command

  attr_writer :format

  def initialize
    @name        = "mutt"
    @description = "Integration with mutt's query_command"

    @format = Ppl::Format::AddressBook::OneLine.new
  end

  def options(parser, options)
    parser.banner = "usage: ppl mutt <query>"
  end

  def execute(input, output)
    query = input.arguments.shift
    address_book = @storage.load_address_book

    matches = mutt_search(address_book)

    line = sprintf(
      "Searching database... %d entries... %d matching:",
      address_book.count,
      matches.length
    )

    output.line(line)

    true
  end


  private

  def mutt_search(address_book)
    []
  end

end

