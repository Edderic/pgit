require 'rake/clean'
require 'rubygems'
require 'rubygems/package_task'
require 'rdoc/task'

Rake::RDocTask.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc","lib/**/*.rb","bin/**/*")
  rd.title = 'PGit'
end

spec = eval(File.read('pgit.gemspec'))

Gem::PackageTask.new(spec) do |pkg|
end

desc 'Run specs'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new
task :default => [:spec]
