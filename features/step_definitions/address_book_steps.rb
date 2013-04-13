
Then /^"([^"]+)" should be a ppl address book$/ do |directory|
  git_directory = File.join(directory, ".git")
  Dir.exist?(git_directory).should eq true
end

