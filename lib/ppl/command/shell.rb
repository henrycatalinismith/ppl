
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
      shell(input, output)
    rescue SystemExit, Interrupt
      terminate_gracefully(input, output)
      false
    end
  end


  private

  def shell(input, output)
    while line = read_line(input)
      break if ["exit", false].include?(line)
      process_line(line)
    end
    terminate_gracefully(input, output)
    true
  end

  def read_line(input)
    prompt = determine_prompt(input.stdin)
    line   = Readline.readline(prompt, true)
  end

  def process_line(line)
    command = "#{$0} #{line}"
    Kernel.system(command)
  end

  def determine_prompt(io)
    if io.tty?
      "ppl> "
    else
      ""
    end
  end

  def terminate_gracefully(input, output)
    if input.stdin.tty?
      output.line("")
    end
  end

end

