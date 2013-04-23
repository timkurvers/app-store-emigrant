require 'spec_helper'

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
    @library.apps.length.must_equal 3
    @library.valid_apps.must_be_instance_of Array
    @library.valid_apps.length.must_equal 2
  end

  it 'can find applications by (partial) filename' do
    @library.find('Dummy').length.must_equal 1
    @library.find('GTA').length.must_equal 1
    @library.find('Soosiz').length.must_equal 1
  end

  it 'can get applications by id' do
    @library.get(344186162).filename.must_equal 'GTA.ipa'
    @library.get(331891505).filename.must_equal 'Soosiz.ipa'
  end

  it 'can load cloud data in bulk' do
    gta = @library.find('GTA').first
    soosiz = @library.find('Soosiz').first
    gta.instance_variable_get('@clouddata').must_be_nil
    soosiz.instance_variable_get('@clouddata').must_be_nil

    Net::HTTP.stub :get, fixture('bulk-clouddata.json') do
      @library.clouddata!
    end

    gta.instance_variable_get('@clouddata').must_be_instance_of Hash
    soosiz.instance_variable_get('@clouddata').must_be_instance_of Hash
  end

end