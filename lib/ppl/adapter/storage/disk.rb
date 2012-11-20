
class Ppl::Adapter::Storage::Disk

  attr_accessor :path
  attr_accessor :vcard_adapter

  def initialize(path)
    @path = path
  end

  def load_address_book
  end

  def load_contact(id)
  end

end

