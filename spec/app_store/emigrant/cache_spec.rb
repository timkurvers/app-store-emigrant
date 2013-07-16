require 'spec_helper'

describe Cache do

  it 'can be deleted' do
    Cache.delete!
    expect(File.directory?(Cache::LOCATION)).to be_false
  end

  it 'will be created when non-existent' do
    Cache.delete!
    expect(File.directory?(Cache::LOCATION)).to be_false

    Cache.ensure!
    expect(File.directory?(Cache::LOCATION)).to be_true
  end

  it 'can report the number of cached items' do
    Cache.clear!
    expect(Cache.count).to eq 0

    App.new(LIBRARY + '/GTA.ipa').cache!
    expect(Cache.count).to eq 1
  end

end
