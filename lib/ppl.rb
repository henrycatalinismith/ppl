
module Ppl

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

  module Factory
  end

end


require "ppl/adapter/storage"
require "ppl/adapter/storage/disk"
require "ppl/adapter/vcard"
require "ppl/adapter/vcard/vpim"

require "ppl/application/bootstrap"
require "ppl/application/command"
require "ppl/application/command_suite"
require "ppl/application/input"
require "ppl/application/output"
require "ppl/application/router"
require "ppl/application/shell"

require "ppl/command/command_list"
require "ppl/command/contact_add"
require "ppl/command/contact_delete"
require "ppl/command/contact_list"
require "ppl/command/contact_show"
require "ppl/command/contact_rename"

require "ppl/entity/address_book"
require "ppl/entity/contact"
require "ppl/entity/email"

require "ppl/error/contact_not_found"
require "ppl/error/incorrect_usage"

class String
  alias_method :each, :each_line
end

