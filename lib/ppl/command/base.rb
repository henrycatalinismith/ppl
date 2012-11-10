
class Ppl::Command::Base


  attr_reader :arguments
  attr_reader :options


  def initialize(arguments=[], options={})
    @arguments = arguments
    @options   = options
  end


end

