
class Ppl::Application::CommandSelector

  attr_reader :commands
  attr_reader :aliases

  def initialize
    @aliases  = []
    @commands = []
  end

  def add_alias(a)
    @aliases.push a
  end

  def add_command(command)
  end

end

