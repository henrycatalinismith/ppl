
require "readline"

class Ppl::Command::Scrape < Ppl::Application::Command

  name        "scrape"
  description "Scrape contact details from stdin"

  attr_writer :email_scraper

  def options(parser, options)
    parser.banner = "usage: ppl scrape [<options>]"
  end

  def execute(input, output)
    contacts = scrape_email(input)
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

  private

  def scrape_email(input)
    ARGV.shift
    email = input.argf.read
    contacts = []
    if input.options[:sender]
      contacts |= scrape_sender(email)
    end
    contacts
  end

  def scrape_sender(email)
    @email_scraper.scrape_contacts(email)
  end

end

