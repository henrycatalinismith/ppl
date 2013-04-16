
require "optparse"

class Ppl::Application::Shell

  attr_writer :router

  def run(input, output)
    outcome = false
    begin
      command = select_command(input)
      prepare_command(command, input)
      outcome = execute_command(command, input, output)
    rescue Ppl::Error::CompletionNotFound
      output.error("ppl: No completion function available for '#{$!}'")
    rescue Ppl::Error::ContactNotFound
      output.error("ppl: Contact '#{$!}' not found")
    rescue OptionParser::InvalidOption, OptionParser::MissingArgument, Ppl::Error::IncorrectUsage
      output.error($!)
      output.error(@optparse.to_s)
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

  def prepare_command(command, input)
    if !command.nil? && !command.is_a?(Ppl::Command::External)
      @optparse = OptionParser.new do |parser|
        command.options(parser, input.options)
      end
      @optparse.parse!(input.arguments)
    end
  end

  def execute_command(command, input, output)
    outcome = false
    if !command.nil?
      outcome = command.execute(input, output)
    end
    return outcome
  end

end

