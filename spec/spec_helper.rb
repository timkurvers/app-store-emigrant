require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start

require 'minitest/stub_const'
require 'minitest/autorun'
require 'mocha/setup'
require 'webmock/minitest'

require 'app-store-emigrant'

# Helper constants
ROOT = File.dirname __FILE__
LIBRARY = ROOT + '/fixtures/dummy-library'

# Clear the cache before running tests
AppStore::Emigrant::Cache.clear!

include AppStore::Emigrant

# Convenience method to retrieve a fixture
def fixture name
  File.read ROOT + '/fixtures/' + name
end
