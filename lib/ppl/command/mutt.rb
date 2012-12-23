
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
    query = require_query(input)
    matches = mutt_search(query)
    output.line(describe_result(matches))
    matches.count > 0
  end


  private

  def require_query(input)
    if input.arguments.first.nil?
      raise Ppl::Error::IncorrectUsage, "You must provide a query"
    end
    input.arguments.first
  end

  def mutt_search(query)
    @address_book = @storage.load_address_book
    matches = Ppl::Entity::AddressBook.new

    @address_book.each do |contact|
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

  def describe_result(matches)
    if matches.count > 0
      describe_matches(matches)
    else
      "No matches"
    end
  end

  def describe_matches(matches)
    summary = sprintf(
      "Searching address book... %d entries... %d matching:",
      @address_book.count,
      matches.count
    )
    results = @format.process(matches)
    [summary, results].join("\n").strip
  end

end

