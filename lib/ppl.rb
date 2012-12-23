
module Ppl

  Version = "1.5.1"

  module Adapter
  end

  module Application
  end

  module Command
  end

  module Entity
  end

  module Error
  end

  module Format
  end

end


require "ppl/adapter/storage"
require "ppl/adapter/storage/disk"
require "ppl/adapter/storage/factory"
require "ppl/adapter/storage/git"
require "ppl/adapter/vcard"
require "ppl/adapter/vcard/vpim"

require "ppl/application/bootstrap"
require "ppl/application/command"
require "ppl/application/command_suite"
require "ppl/application/configuration"
require "ppl/application/input"
require "ppl/application/output"
require "ppl/application/router"
require "ppl/application/shell"

require "ppl/command/init"
require "ppl/command/bday"
require "ppl/command/ls"
require "ppl/command/add"
require "ppl/command/rm"
require "ppl/command/help"
require "ppl/command/show"
require "ppl/command/mv"
require "ppl/command/name"
require "ppl/command/email"
require "ppl/command/org"
require "ppl/command/phone"
require "ppl/command/mutt"
require "ppl/command/post"
require "ppl/command/shell"

require "ppl/entity/address_book"
require "ppl/entity/contact"
require "ppl/entity/postal_address"

require "ppl/error/contact_not_found"
require "ppl/error/incorrect_usage"

require "ppl/format/address_book"
require "ppl/format/address_book/birthdays"
require "ppl/format/address_book/email_addresses"
require "ppl/format/address_book/mutt_query"
require "ppl/format/address_book/names"
require "ppl/format/address_book/one_line"
require "ppl/format/address_book/organizations"
require "ppl/format/address_book/phone_numbers"
require "ppl/format/address_book/postal_addresses"
require "ppl/format/contact"
require "ppl/format/contact/birthday"
require "ppl/format/contact/email_addresses"
require "ppl/format/contact/full"
require "ppl/format/contact/name"
require "ppl/format/contact/organization"
require "ppl/format/contact/phone_number"
require "ppl/format/contact/postal_address"
require "ppl/format/table"

class String
  alias_method :each, :each_line
end

