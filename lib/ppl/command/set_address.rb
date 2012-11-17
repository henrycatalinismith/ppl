
class Ppl::Command::SetAddress < Ppl::Command

  def name
    "address"
  end

  def summary
    "Set a contact's physical address"
  end

  def banner
    "Usage: ppl address <contact> <location> [options]"
  end

  def commit_on_success
    true
  end

  def options(parser)
    parser.on("--city <city>", "City or locality") do |city|
      @options[:city] = city
    end
    parser.on("--country <country>", "Country") do |country|
      @options[:country] = country
    end
    parser.on("--postalcode <postalcode>", "Postal code or ZIP") do |postalcode|
      @options[:postalcode] = postalcode
    end
    parser.on("--region <region>", "Region, province or state") do |region|
      @options[:region] = region
    end
    parser.on("--street <street>", "Street address") do |street|
      @options[:street] = street
    end
  end

  def execute(argv, options)

    contact_id = argv.shift
    location   = argv.shift

    if contact_id.nil? || location.nil?
      $stderr.puts @option_parser
      return false
    end

    contact = @address_book.contact contact_id
    if contact.nil?
      raise "contact '#{contact_id}' not found"
    end

    contact.set_address(location, options)

    puts contact.to_s

    @address_book.save_contact contact

    false
  end

end

