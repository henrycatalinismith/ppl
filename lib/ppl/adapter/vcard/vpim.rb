
require "vpim/vcard"
require "digest/sha1"

class Ppl::Adapter::Vcard::Vpim

  @@postal_address_property_map = {
    :street     => :street,
    :postalcode => :postal_code,
    :pobox      => :po_box,
    :country    => :country,
    :region     => :region,
    :locality   => :locality,
    :preferred  => :preferred,
  }

  def encode(contact)
    vcard = Vpim::Vcard::Maker.make2 do |maker|
      encode_birthday(contact, maker)
      encode_name(contact, maker)
      encode_email_addresses(contact, maker)
      encode_phone_numbers(contact, maker)
      encode_nicknames(contact, maker)
      encode_organizations(contact, maker)
      encode_postal_addresses(contact, maker)
      encode_urls(contact, maker)
    end
    vcard.to_s
  end

  def decode(string)
    vcard   = Vpim::Vcard.decode(string).first
    contact = Ppl::Entity::Contact.new
    decode_birthday(vcard, contact)
    decode_email_addresses(vcard, contact)
    decode_phone_numbers(vcard, contact)
    decode_postal_addresses(vcard, contact)
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
      name.given      = contact.name.given  unless contact.name.given.nil?
      name.family     = contact.name.family unless contact.name.family.nil?
      name.additional = contact.name.middle unless contact.name.middle.nil?
      name.fullname   = contact.name.full   unless contact.name.full.nil?
      name.prefix     = contact.name.prefix   unless contact.name.prefix.nil?
      name.suffix     = contact.name.suffix   unless contact.name.suffix.nil?
    end
  end

  def encode_email_addresses(contact, vcard_maker)
    contact.email_addresses.each do |email_address|
      vcard_maker.add_email(email_address.address) do |vcard_email|
        vcard_email.preferred = email_address.preferred
      end
    end
  end

  def encode_phone_numbers(contact, vcard_maker)
    contact.phone_numbers.each do |phone_number|
      vcard_maker.add_tel(phone_number.number) do |tel|
        tel.location = phone_number.type
        tel.preferred = phone_number.preferred
      end
    end
  end

  def encode_organizations(contact, vcard_maker)
    if !contact.organizations.empty?
      vcard_maker.org = contact.organizations
    end
  end

  def encode_postal_addresses(contact, vcard_maker)
    contact.postal_addresses.each do |postal_address|
      vcard_maker.add_addr do |vcard_address|
        encode_postal_address(postal_address, vcard_address)
      end
    end
  end

  def encode_postal_address(ppl_address, vcard_address)
    vcard_address.location = ppl_address.id
    @@postal_address_property_map.each_pair do |vpim_name, ppl_name|
      value = ppl_address.send(ppl_name)
      if !value.nil?
        vcard_address.send("#{vpim_name.to_s}=", value)
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
    contact.name = Ppl::Entity::Name.new
    if !vcard.name.nil?
      contact.name.full = vcard.name.fullname
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
      email_address = Ppl::Entity::EmailAddress.new(email.to_s)
      email_address.preferred = email.preferred
      contact.email_addresses << email_address
    end
  end

  def decode_postal_addresses(vcard, contact)
    vcard.addresses.each do |vcard_address|
      postal_address = decode_postal_address(vcard_address)
      contact.postal_addresses << postal_address
    end
  end

  def decode_postal_address(vcard_address)
    postal_address = Ppl::Entity::PostalAddress.new
    postal_address.id = determine_postal_address_id(vcard_address)
    @@postal_address_property_map.each_pair do |vpim_name, ppl_name|
      value  = vcard_address.send(vpim_name)
      method = "#{ppl_name.to_s}="
      postal_address.send(method, value)
    end
    postal_address
  end

  def determine_postal_address_id(vcard_address)
    id = (vcard_address.location | vcard_address.nonstandard).join
    if id == ""
      id = Digest::SHA1.hexdigest([
        vcard_address.country,
        vcard_address.delivery,
        vcard_address.locality,
        vcard_address.pobox,
        vcard_address.postalcode,
        vcard_address.region,
        vcard_address.street,
      ].join)[0..6]
    end
    id
  end

  def decode_phone_numbers(vcard, contact)
    vcard.telephones.each do |tel|
      phone_number = Ppl::Entity::PhoneNumber.new
      phone_number.number = tel.to_s
      phone_number.type = (tel.location | tel.nonstandard).join
      phone_number.preferred = tel.preferred
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

