class Ppl::Adapter::Vcard

  def encode(contact)
    raise NotImplementedError
  end

  def decode(string)
    raise NotImplementedError
  end

end

