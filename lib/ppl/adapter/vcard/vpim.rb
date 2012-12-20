
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

      if !contact.phone_number.nil?
        maker.add_tel(contact.phone_number)
      end

      if !contact.organization.nil?
        maker.org=(contact.organization)
      end

      if !contact.postal_address.nil?
        maker.add_addr do |address|
          if !contact.postal_address.street.nil?
            address.street = contact.postal_address.street
          end
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
      contact.email_address = email.to_s
    end

    if !vcard.telephones.empty?
      contact.phone_number = vcard.telephones.first
    end

    if !vcard.address.nil?
      contact.postal_address = Ppl::Entity::PostalAddress.new
      contact.postal_address.street = vcard.address.street
    end

    if !vcard.org.nil?
      contact.organization = vcard.org.first
    end

    name = nil
    name = vcard.name

    if !name.nil?
      contact.name = name.fullname
    end

    return contact
  end

end

