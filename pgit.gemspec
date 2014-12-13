# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','pgit','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'pgit'
  s.version = Pgit::VERSION
  s.author = 'Edderic Ugaddan'
  s.email = 'edderic@gmail.com'
  s.homepage = 'https://github.com/Edderic/pgit'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Optimize your Pivotal Tracker and Github workflow'
  s.files = `git ls-files`.split("
")
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.markdown']
  s.rdoc_options << '--title' << 'pgit' << '--main'
  s.bindir = 'bin'
  s.executables << 'pgit'
  s.add_development_dependency('rake')
  s.add_development_dependency('rpsec', '~> 3.0.0')
  s.add_runtime_dependency('gli','2.12.2')
  s.license = 'MIT'
  s.requirements << 'At least one project that uses Pivotal Tracker and Git'
  s.requirements << 'cURL, at least 7.35.0'
  s.required_ruby_version = '>= 1.9.3'
  s.post_install_message = <<-MESSAGE

  If you are a first time user, please run `pgit install` to save the example
  configuration file under ~/.pgit.rc.yml and edit the file accordingly.

  For more info:
    `pgit --help`

  For feature requests and bug reporting: https://github.com/Edderic/pgit

  Thanks for installing!

  MESSAGE
end
