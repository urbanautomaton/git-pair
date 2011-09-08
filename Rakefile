require 'bundler'
Bundler::GemHelper.install_tasks

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features)

  task :features => :check_dependencies
rescue LoadError
  task :features do
    abort "Cucumber is not available. In order to run features, you must: sudo gem install cucumber"
  end
end

task :default => :features

# Don't print commands when shelling out (for example, running Cucumber)
RakeFileUtils.verbose(false)

