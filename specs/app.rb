require 'app-store-emigrant'
require 'helpers'
require 'minitest/spec'
require 'minitest/autorun'

include AppStore::Emigrant

describe App do
  
  LIBRARY = ROOT + '/fixtures/dummy-library'
  
  before do
    @dummy = App.new(LIBRARY + '/Dummy.ipa')
    @outdated = App.new(LIBRARY + '/Outdated.ipa')
  end
  
  it 'must be a valid file on disk' do
    lambda do
      App.new(LIBRARY + '/Non-Existent.ipa')
    end.must_raise App::DoesNotExist
  end
  
  it 'must have a valid extension' do
    lambda do
      App.new(LIBRARY + '/Non-Existent.ipa')
    end.must_raise App::DoesNotExist
  end
  
  it 'can determine its own filename' do
    @dummy.filename.must_equal 'Dummy.ipa'
  end
  
  it 'can handle invalid structures' do
    lambda do
      @dummy.version
    end.must_raise App::Invalid
  end
  
  it 'can query local metadata' do
    @outdated.version.must_equal '0.9'
  end
  
  it 'can query clouddata' do
    @outdated.cloudversion.must_equal '1.1.0'
  end
  
  it 'can determine whether it is outdated' do
    @outdated.outdated?.must_equal true
  end
  
end
