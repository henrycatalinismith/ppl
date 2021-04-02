require "fakefs/safe"
require "pathname"
require "pry"
require "rspec"

bin_file = Pathname.new(__FILE__).realpath
$:.unshift File.expand_path("../../lib", bin_file)

RSpec::Expectations.configuration.on_potential_false_positives = :nothing

require "ppl"
