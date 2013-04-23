
class Ppl::Format::Custom

  attr_accessor :format

  def self.format(symbol, &block)
    @format_blocks ||= {}
    @format_blocks[symbol] = block
  end

  def self.process(key, object)
    if @format_blocks[key]
      @format_blocks[key][object]
    else
      key
    end
  end

  def initialize(format = nil)
    @format = format
  end

  def process(object)
    @object = object
    string_pieces = @format.scan(/[^%]+|%./)
    string_pieces.map(&method(:process_piece)).join
  end

  private

  def process_piece(string)
    if string[0...1] == "%"
      letter = string[1..-1]
      self.class.process(letter.to_sym, @object)
    else
      string
    end
  end

end

