
class Ppl::Command::Mutt < Ppl::Application::Command

  attr_writer :format

  def initialize
    @name        = "mutt"
    @description = "Integration with mutt's query_command"

    @format = Ppl::Format::AddressBook::MuttQuery.new
  end

  def options(parser, options)
    parser.banner = "usage: ppl mutt <query>"
  end

  def execute(input, output)
    query = input.arguments.shift
    if query.nil?
      raise Ppl::Error::IncorrectUsage, "You must provide a query"
    end

    address_book = @storage.load_address_book

    matches = mutt_search(address_book, query)

    if matches.count > 0

      line = sprintf(
        "Searching database... %d entries... %d matching:",
        address_book.count,
        matches.count
      )

      results = @format.process(matches)

      output.line(line)
      output.line(results) unless results == ""
      true

    else
      output.line("No matches")
      false
    end

  end


  private

  def mutt_search(address_book, query)
    matches = Ppl::Entity::AddressBook.new

    address_book.each do |contact|
      next if contact.email_addresses.empty?

      matching_emails = contact.email_addresses.select do |email_address|
        email_address.include? query
      end

      if matching_emails.length > 0
        matches.add_contact(contact)
      elsif !contact.name.nil? && contact.name.include?(query)
        matches.add_contact(contact)
      end
    end

    matches
  end

end

