require 'app-store-emigrant'
require 'helpers'
require 'minitest/spec'
require 'minitest/autorun'

include AppStore::Emigrant

describe App do
  
  LIBRARY = ROOT + '/fixtures/dummy-library'
  
  before do
    @dummy = App.new(LIBRARY + '/Dummy.ipa')
    @gta = App.new(LIBRARY + '/GTA.ipa')
    @soosiz = App.new(LIBRARY + '/Soosiz.ipa')
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
    @gta.filename.must_equal 'GTA.ipa'
    @soosiz.filename.must_equal 'Soosiz.ipa'
  end
  
  it 'can handle invalid structures' do
    lambda do
      @dummy.version
    end.must_raise App::Invalid
  end
  
  it 'can query local metadata' do
    @gta.version.must_equal '0.9'
    @soosiz.version.must_equal '1.1'
  end
  
  it 'can load cloud data' do
    @gta.cloudversion.must_equal '1.1.0'
    @soosiz.cloudversion.must_equal '1.3'
  end
  
  it 'can determine whether it is outdated' do
    @gta.outdated?.must_equal true
    @soosiz.outdated?.must_equal true
  end
  
end
