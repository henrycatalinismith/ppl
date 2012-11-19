
require "vpim/vcard"

class Ppl::Adapter::Vcard::Vpim

  def encode(contact)
    vcard = Vpim::Vcard::Maker.make2 do |maker|

      maker.birthday = contact.birthday

      maker.add_name do |name|
        name.given = "test"
      end
    end

    return vcard.to_s
  end

  def decode(string)
  end

end

