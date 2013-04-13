
require "tmpdir"

Given /^I am in an empty directory$/ do
  @directory = Dir.mktmpdir
  Dir.chdir @directory
  at_exit do
    FileUtils.rm_rf @directory
  end
end

