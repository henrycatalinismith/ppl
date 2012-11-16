
class Ppl::Command::SetEmail < Ppl::Command

  def name
    "set:email"
  end

  def summary
    "Set a contact's email address"
  end

  def banner
    "Usage: ppl set:email <contact> <email> [options]"
  end

  def commit_on_success
    true
  end

  def options(parser)
    parser.on("--location <location>", "Location, e.g. 'home' or 'work'") do |email|
      @options[:location] = location
    end
    parser.on("--preferred", "Make this the preferred address for this contact") do |preferred|
      @options[:preferred] = preferred
    end
  end

  def execute(argv, options)

    contact_id = argv.first

    if contact_id.nil?
      $stderr.puts @option_parser
      return false
    end

    contact = @address_book.contact contact_id
    if contact.nil?
      raise "contact '#{contact_id}' not found"
    end

    false
  end

end

