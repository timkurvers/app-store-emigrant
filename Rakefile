require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = FileList['specs/*.rb']
  t.verbose    = true
  t.libs      << 'specs'
end

task :default => :test
