
class Ppl::Command::Help < Ppl::Command

  @@default_colors = {
    :name => "white",
    :desc => "blue",
  }

  def name
    "help"
  end

  def summary
    "Show a list of available commands"
  end

  def banner
    "Usage: ppl [--version] [--help] <command> [<args>]"
  end

  def options(parser)
    parser.on("-v", "--version", "Show the version number") do |v|
      @options[:version] = true
    end
  end

  def execute(argv, options)

    if options[:version]
      puts "ppl version " + Ppl::Version
      return true
    end

    max_length = 0
    @commands.each do |command|
      if command.name == self.name
        next
      end

      length = command.name.length
      if length > max_length
        max_length = length
      end
    end

    max_length += 4

    puts self.banner
    puts
    @commands.each do |command|
      if command.name == self.name
        next
      end
      output({
        :name => sprintf("   %-#{max_length}s", command.name),
        :desc => sprintf("%s", command.summary),
      })
    end
    puts
  end

end

