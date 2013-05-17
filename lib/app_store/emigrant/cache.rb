require 'pathname'

module AppStore; end

module AppStore::Emigrant

  # Cache mechanism
  class Cache

    # Cache location
    LOCATION = Pathname.new('~/.ase-cache').expand_path

    # Ensures cache location availability
    def self.ensure!
      unless LOCATION.directory?
        LOCATION.mkpath
      end
      LOCATION
    end

    # Whether cache has this item
    def self.has? item
      ensure!.join(item).file?
    end

    # Path to given item (whether existent or not)
    def self.path_to item
      ensure!.join(item).to_s
    end

    # Forcefully clears the cache
    def self.clear!
      ensure!.children.each do |item|
        item.delete if item.file?
      end
    end

    # Deletes cache
    def self.delete!
      clear!
      LOCATION.delete
    end

    # Number of items in the cache
    def self.count
      ensure!.children.select do |item|
        item.file?
      end.length
    end

  end

end
