
class Ppl::Adapter::Storage::Git

  attr_accessor :disk

  def initialize(disk)
    @disk = disk
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

