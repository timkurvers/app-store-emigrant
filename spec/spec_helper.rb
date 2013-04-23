require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start

require 'minitest/spec'
require 'minitest/autorun'

require 'app-store-emigrant'

# Helper constant holding path to tests-folder
ROOT = File.dirname __FILE__

# Clear the cache before running tests
AppStore::Emigrant::Cache.clear!

include AppStore::Emigrant

# Convenience method to retrieve a fixture
def fixture name
  File.read ROOT + '/fixtures/' + name
end
