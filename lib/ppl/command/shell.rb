
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
    prompt = determine_prompt(input)
    begin
      while line = Readline.readline(prompt, true)
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


  private

  def determine_prompt(input)
    if input.stdin.tty?
      "ppl> "
    else
      ""
    end
  end

end

