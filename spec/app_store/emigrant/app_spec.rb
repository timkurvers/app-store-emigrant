require 'spec_helper'

describe App do

  before do
    @dummy = App.new(LIBRARY + '/Dummy.ipa')
    @gta = App.new(LIBRARY + '/GTA.ipa')
    @soosiz = App.new(LIBRARY + '/Soosiz.ipa')
  end

  it 'must be a valid file on disk' do
    expect do
      App.new(LIBRARY + '/Non-Existent.ipa')
    end.to raise_error App::DoesNotExist
  end

  it 'must have a valid extension' do
    expect do
      App.new(LIBRARY + '/Non-Existent.ipa')
    end.to raise_error App::DoesNotExist
  end

  it 'can determine its own filename' do
    expect(@gta.filename).to eq 'GTA.ipa'
    expect(@soosiz.filename).to eq 'Soosiz.ipa'
  end

  it 'will report invalid structures' do
    expect(@dummy).not_to be_valid
    expect(@dummy.id).to be_nil
    expect(@dummy.version).to be_nil
  end

  it 'can extract its name' do
    expect(@gta.name).to eq 'Grand Theft Auto: Chinatown Wars'
    expect(@soosiz.name).to eq 'Soosiz'
  end

  it 'can query local metadata' do
    expect(@gta.version).to eq '0.9'
    expect(@soosiz.version).to eq '1.1'
  end

  it 'can load cloud data' do
    stub_request(:get, 'http://itunes.apple.com/lookup?id=344186162').to_return :body => fixture('api/GTA.json')
    stub_request(:get, 'http://itunes.apple.com/lookup?id=331891505').to_return :body => fixture('api/Soosiz.json')

    expect(@gta.cloudversion).to eq '1.1.0'
    expect(@soosiz.cloudversion).to eq '1.3'
  end

  it 'can determine whether it is outdated' do
    stub_request(:get, 'http://itunes.apple.com/lookup?id=344186162').to_return :body => fixture('api/GTA.json')
    stub_request(:get, 'http://itunes.apple.com/lookup?id=331891505').to_return :body => fixture('api/Soosiz.json')

    expect(@gta).to be_outdated
    expect(@soosiz).to be_outdated
  end

  it 'can deal with malformed versions' do
    @dummy.stub :version => '1.2.0 (27)'
    @dummy.stub :cloudversion => '1.2.0 (27)'
    expect(@dummy).not_to be_outdated
  end

  it 'can deal with oddities between local and cloud versions' do

    # Chrome
    @dummy.stub :version => '26.1410.53'
    @dummy.stub :cloudversion => '26.0.1410.53'
    expect(@dummy).not_to be_outdated

    # Facebook (in the past)
    @dummy.stub :version => '4100.0'
    @dummy.stub :cloudversion => '4.1'
    expect(@dummy).not_to be_outdated

    # Lara Croft and the Guardian of Light
    @dummy.stub :version => '11.2'
    @dummy.stub :cloudversion => '1.1'
    expect(@dummy).not_to be_outdated

    # Monkey Island 2 Special Edition: LeChuck's Revenge
    @dummy.stub :version => '1.11'
    @dummy.stub :cloudversion => '1.1'
    expect(@dummy).not_to be_outdated

    # UP (in the past)
    @dummy.stub :version => '1.5.15'
    @dummy.stub :cloudversion => '1.5'
    expect(@dummy).not_to be_outdated

  end

end
