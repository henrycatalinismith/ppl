class Ppl::Format::Custom::PhoneNumber < Ppl::Format::Custom

  format :n do |phone_number|
    phone_number.number
  end

  format :t do |phone_number|
    phone_number.type
  end

  format :f do |phone_number|
    if phone_number.preferred
      "*"
    end
  end

end

