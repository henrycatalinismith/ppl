
require "readline"

class Ppl::Command::Scrape < Ppl::Application::Command

  name        "scrape"
  description "Scrape contact details from stdin"

  attr_writer :email_scraper

  def options(parser, options)
    parser.banner = "usage: ppl scrape [<options>]"
  end

  def execute(input, output)
    ARGV.shift
    contacts = @email_scraper.scrape_contacts(input.argf.read)
    contacts.each do |contact|
      if input.options[:quiet]
        decision = "y"
      else
        decision = Readline.readline("test: ")
      end
      if decision == "y"
        @storage.save_contact(contact)
      end
    end
    return true
  end

end

