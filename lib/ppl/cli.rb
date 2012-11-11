
require "ppl"
require "ppl/command"

class Ppl::CLI

  def self.start(*args)

    command = args.shift
    if command
      command = command.strip
    else
      command = "help"
    end

    Ppl::Command.load
    Ppl::Command.run(command, args)

  end

end

