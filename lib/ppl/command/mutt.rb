
class Ppl::Command::Mutt < Ppl::Application::Command

  name        "mutt"
  description "Integration with mutt's query_command"

  attr_writer :format

  def options(parser, options)
    parser.banner = "usage: ppl mutt <query>"
    parser.on("-i", "--ignore-case", "Turn off case sensitivity") do |i|
      options[:ignore_case] = i
    end
  end

  def execute(input, output)
    @options = input.options
    query = require_query(input)
    matches = mutt_search(query)
    output.line(describe_result(matches))
    matches.contacts.length > 0
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
    select_matching_contacts(@address_book, query)
  end

  def select_matching_contacts(address_book, query)
    matches = Ppl::Entity::AddressBook.new
    address_book.contacts.each do |contact|
      contact = contact.dup
      if contact.email_addresses.empty?
        next
      elsif match_by_name(contact, query)
        matches.contacts << contact
      elsif match_by_email_address(contact, query)
        matches.contacts << contact
      end
    end
    matches
  end

  def match_by_name(contact, query)
    if @options[:ignore_case]
      contact.name.full.downcase.include? query.downcase
    else
      contact.name.full.include? query
    end
  end

  def match_by_email_address(contact, query)
    matches = contact.email_addresses.select do |email_address|
      if @options[:ignore_case]
        email_address.address.downcase.include? query.downcase
      else
        email_address.address.include? query
      end
    end
    if matches.length > 0
      contact.email_addresses = matches
      true
    end
  end

  def describe_result(matches)
    if matches.contacts.length > 0
      describe_matches(matches)
    else
      "No matches"
    end
  end

  def describe_matches(matches)
    summary = sprintf(
      "Searching address book... %d email addresses... %d matching:",
      @address_book.contacts.inject(0) { |total, c| total += c.email_addresses.length },
      matches.contacts.inject(0) { |total, c| total += c.email_addresses.length }
    )
    results = @format.process(matches)
    [summary, results].join("\n").strip
  end

end

