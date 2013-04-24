
class Ppl::Format::Custom::EmailAddress < Ppl::Format::Custom

  format :a do |email_adddress|
    email_adddress.address
  end

end

