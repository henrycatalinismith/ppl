
require "ppl"
require "ppl/command"

class Ppl::CLI

  def self.start(*args)
    command = args.shift.strip

    Ppl::Command.load
    Ppl::Command.run(command, args)

  end

end

