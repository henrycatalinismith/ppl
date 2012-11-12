
class Ppl::Command::Help < Ppl::Command

  def name
    "help"
  end

  def summary
    "Show a list of available commands"
  end

  def index

    puts
    Ppl::Command.constants.each do |constant|
      if constant.to_s != "Base"
        command = Ppl::Command.const_get(constant).new(@arguments, @options)
        puts(
          sprintf(" %-10s", command.name) +
          sprintf("%s", command.summary)
        )
      end
    end
    puts

  end

end

