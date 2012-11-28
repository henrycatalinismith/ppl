
class Ppl::Adapter::Storage::Git < Ppl::Adapter::Storage::Disk

  def load_contact(id)
    super(id)
  end

  def save_contact(contact)
    super(contact)
  end

  private

  def commit
  end

end

