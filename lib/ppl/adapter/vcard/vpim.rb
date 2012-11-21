
require "vpim/vcard"

class Ppl::Adapter::Vcard::Vpim

  def encode(contact)
    vcard = Vpim::Vcard::Maker.make2 do |maker|

      if !contact.birthday.nil?
        maker.birthday = contact.birthday
      end

      if !contact.name.nil?
        maker.add_name do |name|
          name.additional = contact.name.additional unless contact.name.additional.nil?
          name.family     = contact.name.family unless contact.name.family.nil?
          name.fullname   = contact.name.full   unless contact.name.full.nil?
          name.given      = contact.name.given  unless contact.name.given.nil?
          name.prefix     = contact.name.prefix unless contact.name.prefix.nil?
          name.suffix     = contact.name.suffix unless contact.name.suffix.nil?
        end
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
      email_address = Ppl::Entity::Email.new
      email_address.address = email.to_s
      contact.email_addresses.push(email_address)
    end

    name = nil
    begin
      name = vcard.name
    rescue
    end

    if !name.nil?
      contact.name = Ppl::Entity::Name.new
      contact.name.given = name.given
      contact.name.family = name.family
      contact.name.additional = name.additional
      contact.name.prefix = name.prefix
      contact.name.suffix = name.suffix
    end

    return contact
  end

end

