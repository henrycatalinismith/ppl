
class Ppl::Adapter::Storage::Disk

  attr_accessor :path
  attr_accessor :vcard_adapter

  def initialize(path)
    @path = path
  end

  def load_address_book
    address_book = Ppl::Entity::AddressBook.new

    pattern   = File.join @path, "*.vcard"
    filenames = Dir.glob pattern

    filenames.each do |filename|
      contact_id = File.basename(filename).slice(0..-7)
      contact    = load_contact(contact_id)
      address_book.add_contact(contact)
    end

    return address_book
  end

  def load_contact(id)
  end

end

