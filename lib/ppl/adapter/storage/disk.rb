
class Ppl::Adapter::Storage::Disk < Ppl::Adapter::Storage

  attr_accessor :path
  attr_accessor :vcard_adapter

  def initialize(path)
    @path = path
  end

  def load_address_book
    address_book = Ppl::Entity::AddressBook.new

    pattern   = File.join @path, "*.vcf"
    filenames = Dir.glob pattern

    filenames.each do |filename|
      contact_id = File.basename(filename).slice(0..-5)
      contact    = load_contact(contact_id)
      address_book.add_contact(contact)
    end

    return address_book
  end

  def load_contact(id)
    filename = File.join @path, id + ".vcf"
    contact  = nil
    if File.exists?(filename)
      vcard   = File.read filename
      contact = @vcard_adapter.decode(vcard)
      if !contact.nil? && contact.is_a?(Ppl::Entity::Contact)
        contact.id = id
      end
    end
    return contact
  end

end

