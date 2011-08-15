$:.push File.expand_path("../lib", __FILE__)
require 'stache/version'

Gem::Specification.new do |s|
  s.name = 'stache'
  s.version = Stache::VERSION
  s.platform = Gem::Platform::RUBY
  s.date = '2011-08-12'
  s.authors = ['Matt Wilson']
  s.email = 'mhw@hypomodern.com'
  s.homepage = 'http://github.com/agoragames/stache'
  s.summary = %Q{Configurable Mustache Handler and Helpers for Rails}
  s.description = %Q{A rails 3.x compatible template handler, configurable.}
  s.extra_rdoc_files = [
    'LICENSE',
    'README.rdoc',
  ]

  s.required_rubygems_version = Gem::Requirement.new('>= 1.3.7')
  s.rubygems_version = '1.3.7'
  s.specification_version = 3

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
  
  s.add_dependency 'mustache'
  s.add_dependency 'rails', '~>3.1.0.rc4'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'bueller'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rcov'
end

