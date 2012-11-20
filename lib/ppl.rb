
module Ppl

  module Adapter
  end

  module Application
  end

  module Command
  end

  module Entity
  end

  module Factory
  end

end


require "ppl/adapter/vcard"
require "ppl/adapter/vcard/vpim"

require "ppl/application/bootstrap"
require "ppl/application/command"
require "ppl/application/command_suite"
require "ppl/application/input"
require "ppl/application/shell"

require "ppl/command/ls"

require "ppl/entity/contact"
require "ppl/entity/name"

require "ppl/factory/contact"

