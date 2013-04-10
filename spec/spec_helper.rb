require 'coveralls'
Coveralls.wear!

require 'minitest/spec'
require 'minitest/autorun'

require 'app-store-emigrant'

# Helper constant holding path to tests-folder
ROOT = File.dirname __FILE__

# Clear the cache before running tests
AppStore::Emigrant::Cache.clear!

include AppStore::Emigrant
