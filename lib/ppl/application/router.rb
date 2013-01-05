
class Ppl::Application::Router

  attr_accessor :aliases
  attr_accessor :default

  def initialize(command_suite)
    @command_suite = command_suite
    @aliases = {}
  end

  def route(argument)
    command = @command_suite.find_command(argument)
    if command.nil? && @aliases.has_key?(argument)
      command = @command_suite.find_command(@aliases[argument])
    end
    if command.nil? && !@default.nil?
      command = @command_suite.find_command(@default)
    end
    return command
  end

end

