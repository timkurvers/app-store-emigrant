require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = FileList['tests/*.rb']
  t.verbose    = true
  t.libs      << 'tests'
end
