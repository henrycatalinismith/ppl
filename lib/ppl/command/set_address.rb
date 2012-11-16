
class Ppl::Command::SetAddress < Ppl::Command

  def name
    "set:address"
  end

  def summary
    "Set a contact's physical address"
  end

  def banner
    "Usage: ppl set:address <contact> [options]"
  end

  def commit_on_success
    true
  end

  def options(parser)
    parser.on("--city <city>", "City or locality") do |email|
      @options[:city] = city
    end
    parser.on("--country <country>", "Country") do |email|
      @options[:country] = country
    end
    parser.on("--postalcode <postalcode>", "Postal code or ZIP") do |email|
      @options[:city] = city
    end
    parser.on("--region <region>", "Region, province or state") do |email|
      @options[:region] = region
    end
    parser.on("--street <street>", "Street address") do |email|
      @options[:street] = street
    end
    parser.on("--location <location>", "Location, e.g. 'home' or 'work'") do |email|
      @options[:location] = location
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

