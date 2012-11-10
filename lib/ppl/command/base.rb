
require "vpim/vcard"
require "colored"

class Ppl::Command::Base


  attr_reader :arguments
  attr_reader :options


  def initialize(arguments=[], options={})
    @arguments = arguments
    @options   = options
  end

  private

  def all_vcards
    pattern   = @options[:path] + "/*.vcard"
    filenames = Dir.glob pattern
    vcards    = {}

    filenames.each do |filename|
      id = File.basename(filename).slice(0..-7)
      vcard = load_vcard id
      vcards[id] = vcard
    end
    vcards
  end

  def load_vcard(id)
    filename = @options[:path] + "/" + id + ".vcard"
    vcard    = IO.read filename
    vcard    = Vpim::Vcard.decode(vcard).first
  end

end

