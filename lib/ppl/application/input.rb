
class Ppl::Application::Input

  attr_accessor :arguments
  attr_accessor :options

  def initialize(arguments=[])
    @arguments = arguments
    @options   = {}
  end

end

