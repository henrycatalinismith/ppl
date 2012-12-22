
require "readline"

class Ppl::Command::Shell < Ppl::Application::Command

  attr_writer :format

  def initialize
    @name        = "shell"
    @description = "Interactive mode"
  end

  def options(parser, options)
    parser.banner = "usage: ppl shell"
  end

  def execute(input, output)
    begin
      while line = Readline.readline("ppl> ", true)
        break if line == "exit"
        break if line == false
        Kernel.system "#{$0} #{line}"
      end
    rescue SystemExit, Interrupt
      output.line("")
      return false
    end

    if $stdin.tty?
      output.line("")
    end
    return true
  end

end

