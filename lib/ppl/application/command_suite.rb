
require "enumerator"

class Ppl::Application::CommandSuite

  include Enumerable

  def initialize
    @commands = []
  end

  def add_command(command)
    @commands.push command
  end

  def each
    @commands.each { |command| yield command }
  end

  def find_command(name)
    @commands.select { |command| command.name == name }.first
  end

end

