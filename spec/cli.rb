require 'spec_helper'

describe CLI do

  it 'can clear the cache' do
    Cache.expects(:clear!)

    capture_io do
      CLI.start ['--clear-cache']
    end
  end

  it 'can verify cache integrity' do
    out, err = capture_io do
      CLI.start ['cache', '--clear-cache', LIBRARY]
    end

    out.must_equal fixture('cli/cache.txt')
  end

  it 'can scan an iTunes library' do
    out, err = capture_io do
      CLI.start ['scan', '--clear-cache', LIBRARY]
    end

    out.must_equal fixture('cli/scan.txt')
  end

  it 'can reports its version' do
    out, err = capture_io do
      CLI.start ['version']
    end

    out.must_equal "App Store Emigrant v#{AppStore::Emigrant::VERSION}\n"
  end

end
