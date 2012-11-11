
class Ppl::Contact

  attr_reader :id

  def initialize(id, vcard)
    @id    = id
    @vcard = vcard
  end

  def birthday
    @vcard.birthday
  end

  def email
    @vcard.emails.first
  end

  def emails
    @vcard.emails
  end

  def name
    @vcard.name.fullname
  end

end

