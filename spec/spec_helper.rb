if RUBY_VERSION >= '1.9.3'
  require 'simplecov'

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter
  ]
  SimpleCov.start
end

require 'webmock/rspec'

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

# Captures IO for the duration of the given block
# See: https://github.com/seattlerb/minitest/blob/master/lib/minitest/assertions.rb#L395
def capture_io
  require 'stringio'

  captured_stdout, captured_stderr = StringIO.new, StringIO.new

  orig_stdout, orig_stderr = $stdout, $stderr
  $stdout, $stderr         = captured_stdout, captured_stderr

  yield

  return captured_stdout.string, captured_stderr.string
ensure
  $stdout = orig_stdout
  $stderr = orig_stderr
end
