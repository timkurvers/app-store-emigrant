require 'spec_helper'

describe CLI do

  it 'can clear the cache' do
    Cache.should_receive :clear!

    capture_io do
      CLI.start ['--clear-cache']
    end
  end

  it 'can verify cache integrity' do
    out, err = capture_io do
      CLI.start ['cache', '--clear-cache', '--library', LIBRARY]
    end

    expect(out).to eq fixture('cli/cache.txt')
  end

  it 'can scan an iTunes library' do
    stub_request(:get, 'http://itunes.apple.com/lookup?id=344186162,331891505').to_return :body => fixture('api/bulk-clouddata.json')

    out, err = capture_io do
      CLI.start ['scan', '--clear-cache', '--library', LIBRARY]
    end

    expect(out).to eq fixture('cli/scan.txt')
  end

  it 'can reports its version' do
    out, err = capture_io do
      CLI.start ['version']
    end

    expect(out).to eq "App Store Emigrant v#{AppStore::Emigrant::VERSION}\n"
  end

end
