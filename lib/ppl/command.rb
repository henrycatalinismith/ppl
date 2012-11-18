
class Ppl::Command

  attr_accessor :address_book
  attr_accessor :commands
  attr_accessor :config

  @@default_colors = {}

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
    begin
      execute_with_options(argv)
    rescue OptionParser::ParseError
      $stderr.puts $!
      $stderr.puts @option_parser
      return false
    rescue RuntimeError
      $stderr.puts "ppl: " + $!.to_s
      return false
    rescue Vpim::InvalidEncodingError
      $stderr.puts "ppl: invalid vcard content '" + $!.to_s + "'"
      return false
    end
    return true
  end

  def execute(argv, options)
    raise NotImplementedError
  end
  
  protected

  def output(line)
    parts = []
    line.each do |i, part|
      color = self.color_for(i)
      if color.nil?
        parts.push(part)
      else
        parts.push(part.send(color))
      end
    end
    puts parts.join
  end


  def color?
    @config["color"][self.name]
  end

  def color_for(element)
    if self.color?
      section = "color \"#{self.name}\""
      if @config[section][element.to_s].nil?
        @@default_colors[element]
      else
        @config[section][element.to_s]
      end
    end
  end


  private

  def execute_with_options(argv)
    @options = {}
    commit_message = self.name + " " + argv.join(" ")
    @option_parser.parse! ARGV
    status = self.execute argv, @options

    if status == true && self.commit_on_success == true
      @address_book.commit(commit_message)
    end
  end

end

