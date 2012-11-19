
class Ppl::Application::CommandSelector

  attr_accessor :commands
  attr_accessor :aliases

  def initialize
    @aliases  = []
    @commands = []
  end

end

