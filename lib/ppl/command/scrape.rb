
class Ppl::Command::Scrape < Ppl::Application::Command

  name        "scrape"
  description "Scrape contact details from stdin"

  attr_writer :format

  def options(parser, options)
    parser.banner = "usage: ppl scrape [<options>]"
  end

  def execute(input, output)
    return true
  end

end

