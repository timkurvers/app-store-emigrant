require 'app-store-emigrant'
require 'helpers'

require 'minitest/spec'
require 'minitest/autorun'

include AppStore::Emigrant

describe Library do
  
  it 'can be located in any valid directory' do
    Library.new ROOT + '/fixtures/dummy-library'
  end
  
  it 'cannot be located in an invalid directory' do
    lambda do
      Library.new(ROOT + '/non-existent-library')
    end.must_raise Library::DoesNotExist
  end
  
  it 'can hold applications' do
    
  end
  
  it 'will load applications lazily' do
    
  end
  
end
