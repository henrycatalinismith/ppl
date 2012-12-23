
class Ppl::Application::Input

  attr_accessor :arguments
  attr_accessor :options
  attr_accessor :stdin

  def initialize(arguments=[])
    @arguments = arguments
    @options   = {}
    @stdin     = $stdin
  end

end

