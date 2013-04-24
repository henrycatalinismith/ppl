
class Ppl::Format::Custom::EmailAddress < Ppl::Format::Custom

  format :a do |email_adddress|
    email_adddress.address
  end

  format :f do |email_adddress|
    if email_adddress.preferred
      "*"
    end
  end

end

