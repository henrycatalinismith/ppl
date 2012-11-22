
class Ppl::Adapter::Storage

  def delete_contact(contact)
    raise NotImplementedError
  end

  def load_address_book
    raise NotImplementedError
  end

  def load_contact(id)
    raise NotImplementedError
  end

  def require_contact(id)
    contact = load_contact(id)
    if contact.nil?
      raise Ppl::Error::ContactNotFound
    end
  end

end

