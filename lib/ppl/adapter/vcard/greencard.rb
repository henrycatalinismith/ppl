
require "greencard/vcard"

class Ppl::Adapter::Vcard::GreenCard

  @@postal_address_property_map = {
    :street     => :street,
    :postalcode => :postal_code,
    :pobox      => :po_box,
    :country    => :country,
    :region     => :region,
    :locality   => :locality,
  }

  def encode(contact)
    vcard = GreenCard::Vcard::Maker.make2 do |maker|
      encode_birthday(contact, maker)
      encode_name(contact, maker)
      encode_email_addresses(contact, maker)
      encode_phone_numbers(contact, maker)
      encode_nicknames(contact, maker)
      encode_organizations(contact, maker)
      encode_postal_address(contact, maker)
      encode_urls(contact, maker)
    end
    vcard.to_s
  end

  def decode(string)
    vcard   = GreenCard::Vcard.decode(string).first
    contact = Ppl::Entity::Contact.new
    decode_birthday(vcard, contact)
    decode_email_addresses(vcard, contact)
    decode_phone_numbers(vcard, contact)
    decode_postal_address(vcard, contact)
    decode_nicknames(vcard, contact)
    decode_organizations(vcard, contact)
    decode_name(vcard, contact)
    decode_urls(vcard, contact)
    return contact
  end


  private

  def encode_birthday(contact, vcard_maker)
    if !contact.birthday.nil?
      vcard_maker.birthday = contact.birthday
    end
  end

  def encode_name(contact, vcard_maker)
    vcard_maker.add_name do |name|
      name.given    = contact.id   unless contact.id.nil?
      name.fullname = contact.name unless contact.name.nil?
    end
  end

  def encode_email_addresses(contact, vcard_maker)
    contact.email_addresses.each do |email_address|
      vcard_maker.add_email(email_address)
    end
  end

  def encode_phone_numbers(contact, vcard_maker)
    contact.phone_numbers.each do |phone_number|
      vcard_maker.add_tel(phone_number.number) do |tel|
        tel.location = phone_number.type
      end
    end
  end

  def encode_organizations(contact, vcard_maker)
    if !contact.organizations.empty?
      vcard_maker.org = contact.organizations
    end
  end

  def encode_postal_address(contact, vcard_maker)
    if !contact.postal_address.nil?
      vcard_maker.add_addr do |address|
        @@postal_address_property_map.each_pair do |vpim_name, ppl_name|
          value = contact.postal_address.send(ppl_name)
          if !value.nil?
            address.send("#{vpim_name.to_s}=", value)
          end
        end
      end
    end
  end

  def encode_urls(contact, vcard_maker)
    contact.urls.each { |url| vcard_maker.add_url(url) }
  end

  def encode_nicknames(contact, vcard_maker)
    vcard_maker.nickname = contact.nicknames
  end

  def decode_birthday(vcard, contact)
    contact.birthday = vcard.birthday unless vcard.birthday.nil?
  end

  def decode_name(vcard, contact)
    if !vcard.name.nil?
      contact.name = vcard.name.fullname
    end
  end

  def decode_organizations(vcard, contact)
    if vcard.org.is_a?(Array)
      contact.organizations = vcard.org
    elsif !vcard.org.nil?
      contact.organizations.push(vcard.org)
    end
  end

  def decode_email_addresses(vcard, contact)
    vcard.emails.each do |email|
      contact.email_addresses.push(email.to_s)
    end
  end

  def decode_postal_address(vcard, contact)
    if !vcard.address.nil?
      contact.postal_address             = Ppl::Entity::PostalAddress.new
      @@postal_address_property_map.each_pair do |vpim_name, ppl_name|
        value  = vcard.address.send(vpim_name)
        method = "#{ppl_name.to_s}="
        contact.postal_address.send(method, value)
      end
    end
  end

  def decode_phone_numbers(vcard, contact)
    vcard.telephones.each do |tel|
      phone_number = Ppl::Entity::PhoneNumber.new
      phone_number.number = tel
      contact.phone_numbers << phone_number
    end
  end

  def decode_urls(vcard, contact)
    vcard.urls.each { |url| contact.urls.push(url.uri) }
  end

  def decode_nicknames(vcard, contact)
    # There appears to be a minor vpim bug here: vpim allows us to save an array
    # of nicknames but sees it as one big single nickname when decoding. This
    # code is here to work around that issue by "finishing the job".
    nicknames = vcard.nicknames.first
    if !nicknames.nil?
      nicknames.split(";").each{ |nickname| contact.nicknames.push(nickname) }
    end
  end

end

