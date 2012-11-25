
require "vpim/vcard"

class Ppl::Adapter::Vcard::Vpim

  def encode(contact)
    vcard = Vpim::Vcard::Maker.make2 do |maker|

      if !contact.birthday.nil?
        maker.birthday = contact.birthday
      end

      maker.add_name do |name|
        name.given    = contact.id   unless contact.id.nil?
        name.fullname = contact.name unless contact.name.nil?
      end

      if !contact.email_address.nil?
        maker.add_email(contact.email_address)
      end

    end

    return vcard.to_s
  end

  def decode(string)
    vcard   = Vpim::Vcard.decode(string).first
    contact = Ppl::Entity::Contact.new

    if !vcard.birthday.nil?
      contact.birthday = vcard.birthday
    end

    vcard.emails.each do |email|
      contact.email_address = email.to_s
    end

    name = nil
    name = vcard.name

    if !name.nil?
      contact.name = name.fullname
    end

    return contact
  end

end

