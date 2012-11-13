
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
    puts @option_parser
    puts
    @commands.each do |command|
      puts(
        sprintf(" %-10s", command.name) +
        sprintf("%s", command.summary)
      )
    end
    puts
  end

end

