
require "rugged"

class Ppl::Adapter::Storage::Git

  attr_accessor :disk
  attr_accessor :repository

  def initialize(disk)
    @disk = disk
    @repository = Rugged::Repository.new(@disk.directory.path)
  end

  def load_contact(id)
  end

  def save_contact(contact)
    @disk.save_contact(contact)
    commit("save_contact(#{contact.id})")
  end

  private

  def commit(message)
  end

end

