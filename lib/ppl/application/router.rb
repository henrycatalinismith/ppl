
class Ppl::Application::Router

  attr_accessor :aliases
  attr_accessor :default
  attr_accessor :execute_command

  def initialize(command_suite)
    @command_suite = command_suite
    @aliases = {}
  end

  def route(argument)
    command = @command_suite.find_command(argument)
    if command.nil? && @aliases.has_key?(argument)
      if is_bang_alias?(argument)
        command = create_execute_command(argument)
      else
        command = @command_suite.find_command(@aliases[argument])
      end
    end
    if command.nil? && !@default.nil?
      command = @command_suite.find_command(@default)
    end
    return command
  end


  private

  def is_bang_alias?(key)
    @aliases[key].match(/^!/)
  end

  def create_execute_command(key)
    @execute_command.name = key
    @execute_command.command = @aliases[key][1..-1]
    @execute_command
  end

end

