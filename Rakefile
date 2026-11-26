task :features => [:disable_config] do
  sh "bundle exec cucumber --publish-quiet"
end

task :disable_config do
  pplconfig = File.expand_path("~/.pplconfig")
  bkpconfig = File.expand_path("~/.pplconfig.bkp")
  if File.exist? pplconfig
    FileUtils.mv pplconfig, bkpconfig
  end
  at_exit { Rake::Task["enable_config"].invoke }
end

task :enable_config do
  pplconfig = File.expand_path("~/.pplconfig")
  bkpconfig = File.expand_path("~/.pplconfig.bkp")
  if File.exist? bkpconfig
    FileUtils.mv bkpconfig, pplconfig
  end
end

task :feature, :feature_name do |task, params|
  Rake::Task["disable_config"].invoke
  sh "bundle exec cucumber features/#{params[:feature_name]}.feature"
  Rake::Task["enable_config"].invoke
end

