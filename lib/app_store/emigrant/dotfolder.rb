require 'pathname'

module AppStore; end

module AppStore::Emigrant

  DOTFOLDER = Pathname.new('~/.app-store-emigrant').expand_path

end
