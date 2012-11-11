
require "vpim/vcard"
require "colored"


class Ppl::Command::Base


  attr_reader :arguments
  attr_reader :options


  def initialize(arguments=[], options={})
    @arguments = arguments
    @options   = options

    @address_book = Ppl::Address_Book.new(@options[:path])
  end


  def name
  end


  def summary
  end

end

