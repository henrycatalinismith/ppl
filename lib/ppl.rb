
module Ppl

  Version = "0.7.0"

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

require "ppl/command/address_book_init"
require "ppl/command/bday"
require "ppl/command/command_list"
require "ppl/command/contact_add"
require "ppl/command/contact_delete"
require "ppl/command/contact_list"
require "ppl/command/contact_show"
require "ppl/command/contact_rename"
require "ppl/command/name"
require "ppl/command/set_email"
require "ppl/command/set_organization"
require "ppl/command/set_phone_number"

require "ppl/entity/address_book"
require "ppl/entity/contact"

require "ppl/error/contact_not_found"
require "ppl/error/incorrect_usage"

require "ppl/format/address_book"
require "ppl/format/address_book/one_line"
require "ppl/format/contact"
require "ppl/format/contact/birthday"
require "ppl/format/contact/email_address"
require "ppl/format/contact/full"
require "ppl/format/contact/name"
require "ppl/format/contact/organization"
require "ppl/format/contact/phone_number"

class String
  alias_method :each, :each_line
end

