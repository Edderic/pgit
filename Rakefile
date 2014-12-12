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
require 'rake/testtask'
Rake::TestTask.new(:spec) do |s|
  s.libs << "spec"
  s.test_files = FileList['spec/**/*_test.rb']
end

task :default => [:spec]
