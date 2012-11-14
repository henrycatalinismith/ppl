
class Ppl::Command

  attr_accessor :address_book
  attr_accessor :commands

  def initialize
    @option_parser = OptionParser.new do |parser|
      parser.banner = self.banner
      self.options parser
    end
  end

  def name
    raise NotImplementedError
  end

  def summary
    raise NotImplementedError
  end

  def banner
    raise NotImplementedError
  end

  def commit_on_success
    false
  end

  def options(parser)
    raise NotImplementedError
  end

  def run(argv)

    commit_message = self.name + " " + argv.join(" ")

    @options = {}
    begin
      @option_parser.parse! ARGV
    rescue OptionParser::ParseError
      $stderr.puts $!
      $stderr.puts @option_parser
      return false
    end

    begin
      status = self.execute argv, @options
    rescue RuntimeError
      $stderr.puts "ppl: " + $!.to_s
    end

    if status == true && self.commit_on_success == true
      @address_book.commit(commit_message)
    end

    return status
  end

  def execute(argv, options)
    raise NotImplementedError
  end

end

