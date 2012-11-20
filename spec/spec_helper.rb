
require "pathname"

bin_file = Pathname.new(__FILE__).realpath
$:.unshift File.expand_path("../../lib", bin_file)

require "ppl"

