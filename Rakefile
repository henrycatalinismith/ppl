
task :build    => [:build193, :build200]
task :build193 => [:ruby193, :spec, :features]
task :build200 => [:ruby200, :spec, :features]

task :features => [:disable_config] do
  system "bundle exec cucumber"
end

task :spec do
  system "bundle exec rspec"
end

task :ruby193 do
  system "bash -lc 'rvm use 1.9.3'"
  Rake::Task["spec"].reenable
  Rake::Task["features"].reenable
end

task :ruby200 do
  system "bash -lc 'rvm use 2.0.0'"
  Rake::Task["spec"].reenable
  Rake::Task["features"].reenable
end

task :disable_config do
  pplconfig = File.expand_path("~/.pplconfig")
  bkpconfig = File.expand_path("~/.pplconfig.bkp")
  if File.exists? pplconfig
    FileUtils.mv pplconfig, bkpconfig
  end
  at_exit { Rake::Task["enable_config"].invoke }
end

task :enable_config do
  pplconfig = File.expand_path("~/.pplconfig")
  bkpconfig = File.expand_path("~/.pplconfig.bkp")
  if File.exists? bkpconfig
    FileUtils.mv bkpconfig, pplconfig
  end
end

