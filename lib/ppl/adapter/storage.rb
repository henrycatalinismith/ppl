
class Ppl::Adapter::Storage

  def load_address_book
    raise NotImplementedError
  end

  def load_contact(id)
    raise NotImplementedError
  end

end

