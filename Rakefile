require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:test) do |spec|
  spec.pattern = 'spec/*.rb'
  spec.rspec_opts = ['--color']
end

task :default => :test
