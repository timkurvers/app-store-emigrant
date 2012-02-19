# encoding: utf-8

$:.push File.expand_path('../lib', __FILE__)

require 'app-store-emigrant/version'

Gem::Specification.new do |s|
  s.name        = 'app-store-emigrant'
  s.version     = AppStore::Emigrant::VERSION
  s.authors     = ['Tim Kurvers']
  s.email       = ['tim@moonsphere.net']
  s.homepage    = 'http://moonsphere.net'
  s.summary     = 'App Store Emigrant will manually attempt to verify whether any of your local mobile applications are out of date'
  s.description = 'Moved countries and now iTunes refuses to notify you properly with updates? Rest assured, using App Store Emigrant you know exactly which apps are outdated'
  
  s.rubyforge_project = 'app-store-emigrant'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
  
  s.add_dependency 'rubyzip',        '~> 0.9.5'
  s.add_dependency 'rainbow',        '~> 1.1.3'
  s.add_dependency 'CFPropertyList', '~> 2.0.17'
  
  s.add_development_dependency 'rake'

end
