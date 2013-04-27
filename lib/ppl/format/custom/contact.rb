
class Ppl::Format::Custom::Contact < Ppl::Format::Custom

  format :n do |anything|
    "\n"
  end

  format :i do |contact|
    contact.id
  end

  format :N do |contact|
    contact.name
  end

  format :a do |contact|
    contact.age(Date.today)
  end

  format :b do |contact|
    unless contact.birthday.nil?
      contact.birthday.strftime("%Y-%m-%d")
    end
  end

  format :k do |contact|
    contact.nicknames.first
  end

  format :e do |contact|
    if !contact.preferred_email_address.nil?
      contact.preferred_email_address.address
    elsif !contact.email_addresses.first.nil?
      contact.email_addresses.first.address
    end
  end

  format :o do |contact|
    contact.organizations.first
  end

  format :p do |contact|
    preferred = contact.phone_numbers.find { |p| p.preferred }
    first = contact.phone_numbers.first
    if !preferred.nil?
      preferred.number
    elsif !first.nil?
      first.number
    end
  end

end

