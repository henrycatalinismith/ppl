
class Ppl::Application::CommandSuite

  attr_reader :commands

  def initialize
    @commands = []
  end

  def add_command(command)
    @commands.push command
  end

end

