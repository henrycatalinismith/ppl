
class Ppl::Command::Help < Ppl::Command

  def name
    "help"
  end

  def summary
    "Show a list of available commands"
  end

  def banner
    "Usage: ppl <command> [options]"
  end

  def options(parser)
  end

  def execute(argv, options)

    max_length = 0
    @commands.each do |command|
      length = command.name.length
      if length > max_length
        max_length = length
      end
    end

    max_length += 1

    puts @option_parser
    puts
    @commands.each do |command|
      puts(
        sprintf(" %-#{max_length}s", command.name) +
        sprintf("%s", command.summary)
      )
    end
    puts
  end

end

