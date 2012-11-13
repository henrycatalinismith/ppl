
class Ppl::Command

  def initialize(address_book, option_parser, sub_commands = [])
    @address_book  = address_book
    @option_parser = option_parser

    @option_parser.banner = banner
    @options = {}
    options
  end

  def name
    "ppl"
  end

  def summary
    ""
  end

  def banner
    "Usage: ppl <command>"
  end

  def options
  end

  def run(argv)
    @options = {}
    @option_parser.parse! argv
    execute(argv, @options)
  end

  def execute(argv, options)
    raise NotImplementedError
  end

end

