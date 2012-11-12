
require "ppl"

class Ppl::Command

  def initialize(arguments=[], options={}, address_book)
    @arguments = arguments
    @options   = options
    @address_book = address_book
  end

  def name
  end

  def summary
  end

end

