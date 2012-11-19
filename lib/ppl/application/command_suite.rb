
class Ppl::Application::CommandSuite

  attr_reader :commands

  def initialize
    @commands = []
  end

  def add_command(command)
    @commands.push command
  end

  def find_command(name)
    @commands.select { |command| command.name == name }.first
  end

end

