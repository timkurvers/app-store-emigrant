require 'app-store-emigrant'
require 'helpers'
require 'minitest/spec'
require 'minitest/autorun'

include AppStore::Emigrant

describe Library do
  
  before do
    @library = Library.new(ROOT + '/fixtures/dummy-library')
  end
  
  it 'must be located in a valid directory' do
    @library.must_be_instance_of Library
    
    lambda do
      Library.new(ROOT + '/non-existent-library')
    end.must_raise Library::DoesNotExist
  end
  
  it 'will gracefully and lazily load applications' do
    @library.instance_variable_get('@apps').must_be_nil
    @library.apps.must_be_instance_of Array
    @library.apps.length.must_equal 2
  end
  
  it 'can find applications' do
    @library.find('Dummy').length.must_equal 1
  end
  
end
