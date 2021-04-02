task :features => [:disable_config] do
  system "bundle exec cucumber"
end

task :spec do
  system "bundle exec rspec"
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

task :feature, :feature_name do |task, params|
  Rake::Task["disable_config"].invoke
  system "bundle exec cucumber features/#{params[:feature_name]}.feature"
  Rake::Task["enable_config"].invoke
end

