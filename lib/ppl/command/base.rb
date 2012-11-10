
class Ppl::Command::Base


  attr_reader :arguments
  attr_reader :options


  def initialize(arguments=[], options={})
    @arguments = arguments
    @options   = options
  end

  private

  def load_vcard(id)
    filename = @options[:path] + "/" + id + ".vcard"
    vcard    = IO.read filename
    vcard    = Vpim::Vcard.decode(vcard).first
  end

end

