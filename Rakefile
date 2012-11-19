
$:.unshift File.expand_path("lib")

require "ppl"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec) do |task|

  task.fail_on_error = true

  task.rspec_opts = [
    "-I " + File.expand_path("lib"),
    "-r " + File.expand_path("lib/ppl.rb"),
  ].join(" ")

end

