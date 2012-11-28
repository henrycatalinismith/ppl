
require "optparse"

class Ppl::Application::Shell

  attr_writer :router

  def run(input, output)
    outcome = false
    begin
      command = select_command(input)
      outcome = execute_command(command, input, output)
    rescue
      output.error("ppl: " + $!.message)
      outcome = false
    end
    return outcome
  end


  private

  def select_command(input)
    @router.route(input.arguments.shift)
  end

  def execute_command(command, input, output)
    outcome = false
    if !command.nil?

      OptionParser.new do |parser|
        command.options(parser, input.options)
      end

      outcome = command.execute(input, output)
    end
    return outcome
  end

end

