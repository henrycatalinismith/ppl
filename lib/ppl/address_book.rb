
require "vpim/vcard"
require "enumerator"

class Ppl::Address_Book

  include Enumerable

  def initialize(path)
    @path = path
  end

  def contact(id)
    filename = File.join @path, id + ".vcard"
    vcard    = IO.read filename
    vcard    = Vpim::Vcard.decode(vcard).first
  end

  def contacts
    pattern   = File.join @path, "*.vcard"
    filenames = Dir.glob pattern
    vcards    = {}

    filenames.each do |filename|
      id = File.basename(filename).slice(0..-7)
      vcard = self.contact(id)
      vcards[id] = vcard
    end
    vcards

  end

  def each
    self.contacts.each { |c| yield c }
  end

end

