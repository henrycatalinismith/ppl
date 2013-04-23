
class Ppl::Format::Custom::Contact < Ppl::Format::Custom

  format :n do |contact|
    contact.name
  end

  format :b do |contact|
    unless contact.birthday.nil?
      contact.birthday.strftime("%Y-%m-%d")
    end
  end

end

