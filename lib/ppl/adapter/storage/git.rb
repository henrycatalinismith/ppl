
require "rugged"

class Ppl::Adapter::Storage::Git

  attr_accessor :disk
  attr_accessor :repository
  attr_accessor :vcard_adapter

  def initialize(disk)
    @disk = disk
    @repository = Rugged::Repository.new(@disk.directory.path)
  end

  def load_contact(id)
    filename = @disk.filename_for_contact_id(id)
    target   = @repository.head.target
    vcard    = @repository.file_at(target, filename)
    contact  = @vcard_adapter.decode(vcard)

    contact.id = id

    return contact
  end

  def save_contact(contact)
    @disk.save_contact(contact)
    commit("save_contact(#{contact.id})")
  end

  private

  def commit(message)
  end

end

