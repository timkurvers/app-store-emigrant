# encoding: utf-8

$:.push File.expand_path('../lib', __FILE__)

require 'app_store/emigrant/version'

Gem::Specification.new do |s|
  s.name        = 'app-store-emigrant'
  s.version     = AppStore::Emigrant::VERSION
  s.authors     = ['Tim Kurvers']
  s.email       = ['tim@moonsphere.net']
  s.homepage    = 'https://github.com/timkurvers/app-store-emigrant'
  s.summary     = 'App Store Emigrant will manually attempt to verify whether any of your local mobile applications are out of date'
  s.description = 'App Store Emigrant will manually attempt to verify whether any of your local mobile applications are out of date, which iTunes - unfortunately - will refuse once you have moved countries'

  s.rubyforge_project = 'app-store-emigrant'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'CFPropertyList', '~> 2.0'
  s.add_dependency 'json',           '~> 1.7.7'
  s.add_dependency 'mime-types',     '~> 1.x'
  s.add_dependency 'rubyzip',        '~> 0.9'
  s.add_dependency 'rainbow',        '~> 1.1'
  s.add_dependency 'thor',           '~> 0.18.0'

  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 2.x'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'webmock'

  if RUBY_VERSION >= '1.9.3'
    s.add_development_dependency 'guard'
    s.add_development_dependency 'guard-rspec'
    s.add_development_dependency 'listen'
  end
end
