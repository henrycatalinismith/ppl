
class Ppl::Application::Input

  attr_accessor :arguments
  attr_accessor :options
  attr_accessor :stdin
  attr_accessor :argf

  def initialize(arguments=[])
    @arguments = arguments
    @options   = {}
    @stdin     = $stdin
    @argf      = ARGF
  end

end

