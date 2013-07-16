require 'spec_helper'

describe Library do

  before do
    @library = Library.new(LIBRARY)
  end

  it 'must be located in a valid directory' do
    expect(@library).to be_an_instance_of Library

    expect do
      Library.new(ROOT + '/non-existent-library')
    end.to raise_error Library::DoesNotExist
  end

  it 'can find default library' do
    stub_const 'AppStore::Emigrant::Library::DEFAULT_LOCATIONS', [@library.path]
    expect(Library.default).to be_an_instance_of Library
  end

  it 'will raise an exception when default library can not be found' do
    stub_const 'AppStore::Emigrant::Library::DEFAULT_LOCATIONS', []
    expect do
      Library.default
    end.to raise_error Library::DoesNotExist
  end

  it 'will gracefully and lazily load applications in alphabetical order' do
    expect(@library.instance_variable_get('@apps')).to be_nil
    expect(@library.apps).to be_an_instance_of Array
    expect(@library.apps.length).to eq 3

    expect(@library.valid_apps).to be_an_instance_of Array
    expect(@library.valid_apps.length).to eq 2
    expect(@library.valid_apps.first.filename).to eq 'GTA.ipa'
    expect(@library.valid_apps.last.filename).to eq 'Soosiz.ipa'

    stub_request(:get, 'http://itunes.apple.com/lookup?id=344186162').to_return :body => fixture('api/GTA.json')
    stub_request(:get, 'http://itunes.apple.com/lookup?id=331891505').to_return :body => fixture('api/Soosiz.json')

    expect(@library.outdated_apps).to be_an_instance_of Array
    expect(@library.outdated_apps.length).to eq 2
    expect(@library.outdated_apps.first.cloudversion).to eq '1.1.0'
    expect(@library.outdated_apps.last.cloudversion).to eq '1.3'
  end

  it 'can find applications by (partial) filename' do
    expect(@library.find('Dummy').length).to eq 1
    expect(@library.find('GTA').length).to eq 1
    expect(@library.find('Soosiz').length).to eq 1
  end

  it 'can get applications by id' do
    expect(@library.get(344186162).filename).to eq 'GTA.ipa'
    expect(@library.get(331891505).filename).to eq 'Soosiz.ipa'
  end

  it 'can load cloud data in bulk' do
    gta = @library.find('GTA').first
    soosiz = @library.find('Soosiz').first
    expect(gta.instance_variable_get('@clouddata')).to be_nil
    expect(soosiz.instance_variable_get('@clouddata')).to be_nil

    stub_request(:get, 'http://itunes.apple.com/lookup?id=344186162,331891505').to_return :body => fixture('api/bulk-clouddata.json')

    @library.clouddata!

    expect(gta.instance_variable_get('@clouddata')).to be_an_instance_of Hash
    expect(soosiz.instance_variable_get('@clouddata')).to be_an_instance_of Hash
  end

end
