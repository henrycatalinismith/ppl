
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
    string_pieces = @format.scan(/[^%]+|%-?\d*./)
    string_pieces.map(&method(:process_piece)).join
  end

  private

  def process_piece(string)
    matches = string.scan(/^%(-?\d+)?([a-z])$/)
    if !matches.empty?
      output = generate_output(matches[0][1].to_sym)
      pad_output(output, matches[0][0].to_i)
    else
      string
    end
  end

  def generate_output(symbol)
    self.class.process(symbol, @object)
  end

  def pad_output(output, padding)
    if padding > 0
      output.rjust(padding, " ")
    elsif padding < 0
      output.ljust(padding.abs, " ")
    else
      output
    end
  end

end

