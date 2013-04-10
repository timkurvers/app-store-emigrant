require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = FileList['spec/*.rb']
  t.verbose    = true
  t.libs      << 'spec'
end

task :default => :test
