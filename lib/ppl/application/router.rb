
class Ppl::Application::Router

  attr_accessor :default

  def initialize(command_suite)
    @command_suite = command_suite
  end

  def route(argument)
    command = @command_suite.find_command(argument)
    if command.nil? && !@default.nil?
      command = @command_suite.find_command(@default)
    end
    return command
  end

end

