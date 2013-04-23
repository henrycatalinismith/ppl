
class Ppl::Format::Custom::Contact < Ppl::Format::Custom

  format :n do |contact|
    contact.name
  end

end

