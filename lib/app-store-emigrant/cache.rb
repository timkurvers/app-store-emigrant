require 'pathname'

module AppStore; end

module AppStore::Emigrant

  # Cache mechanism
  class Cache

    LOCATION = begin
      path = Pathname.new('~/.ase-cache').expand_path
      unless path.directory?
        path.mkpath
      end
      path
    end

    # Whether cache has this item
    def self.has? item
      LOCATION.join(item).file?
    end

    # Path to given item (whether existent or not)
    def self.path_to item
      LOCATION.join(item).to_s
    end

    # Forcefully clears the cache
    def self.clear!
      LOCATION.children.each do |item|
        item.delete if item.file?
      end
    end

    # Number of items in the cache
    def self.count
      LOCATION.children.select { |item| item.file? }.length
    end

  end

end
