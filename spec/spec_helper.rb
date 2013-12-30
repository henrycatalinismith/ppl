
require "fakefs/safe"
require "pathname"

bin_file = Pathname.new(__FILE__).realpath
$:.unshift File.expand_path("../../lib", bin_file)

if ENV['CI']
  require "coveralls"
  Coveralls.wear!
end

require "ppl"

