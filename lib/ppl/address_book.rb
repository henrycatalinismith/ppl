
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
    contact  = Ppl::Contact.new(id, vcard)
  end

  def contacts
    pattern   = File.join @path, "*.vcard"
    filenames = Dir.glob pattern
    contacts  = []

    filenames.each do |filename|
      id = File.basename(filename).slice(0..-7)
      contacts.push self.contact(id);
    end
    contacts

  end

  def each
    self.contacts.each { |c| yield c }
  end

  def with_birthday
    self.find_all { |contact| contact.birthday.nil? == false }
  end

end

