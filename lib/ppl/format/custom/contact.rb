
class Ppl::Format::Custom::Contact < Ppl::Format::Custom

  format :i do |contact|
    contact.id
  end

  format :N do |contact|
    contact.name
  end

  format :b do |contact|
    unless contact.birthday.nil?
      contact.birthday.strftime("%Y-%m-%d")
    end
  end

  format :e do |contact|
    preferred = contact.email_addresses.find { |e| e.preferred }
    first = contact.email_addresses.first
    if !preferred.nil?
      preferred.address
    elsif !first.nil?
      first.address
    end
  end

  format :o do |contact|
    contact.organizations.first
  end

end

