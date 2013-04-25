require 'spec_helper'

describe Cache do

  it 'can be deleted' do
    Cache.delete!
    File.directory?(Cache::LOCATION).must_equal false
  end

  it 'will be created when non-existent' do
    Cache.delete!
    File.directory?(Cache::LOCATION).must_equal false

    Cache.ensure!
    File.directory?(Cache::LOCATION).must_equal true
  end

  it 'can report the number of cached items' do
    Cache.clear!
    Cache.count.must_equal 0

    App.new(LIBRARY + '/GTA.ipa').cache!
    Cache.count.must_equal 1
  end

end
