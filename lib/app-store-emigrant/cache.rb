require 'pathname'

module AppStore; end

module AppStore::Emigrant

  # Cache mechanism
  class Cache

    PATH = begin
      path = Pathname.new('~/.ase-cache').expand_path
      unless path.directory?
        path.mkpath
      end
      path
    end

    # Whether cache has this item
    def self.has? item
      PATH.join(item).file?
    end

    # Path to given item (whether existent or not)
    def self.path_to item
      PATH.join(item).to_s
    end

    # Forcefully clears the cache
    def self.clear!
      # TODO: Implement clearing cache
    end

  end

end
