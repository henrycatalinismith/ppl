
class Ppl::Command::SetEmail < Ppl::Command

  def name
    "email"
  end

  def summary
    "Set a contact's email address"
  end

  def banner
    "Usage: ppl email <contact> <email> [options]"
  end

  def commit_on_success
    true
  end

  def options(parser)
    parser.on("--location <location>", "Location, e.g. 'home' or 'work'") do |location|
      @options[:location] = location
    end
    parser.on("--preferred", "Make this the preferred address for this contact") do |preferred|
      @options[:preferred] = preferred
    end
  end

  def execute(argv, options)

    contact_id    = argv.shift
    email_address = argv.shift

    if contact_id.nil? || email_address.nil?
      $stderr.puts @option_parser
      return false
    end

    contact = @address_book.contact contact_id
    if contact.nil?
      raise "contact '#{contact_id}' not found"
    end

    contact.set_email(email_address, options[:location], options[:preferred])

    @address_book.save_contact contact

    true
  end

end

