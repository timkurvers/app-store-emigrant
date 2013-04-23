require 'json'
require 'net/http'
require 'pathname'

module AppStore; end

module AppStore::Emigrant

  # Represents a single iTunes mobile applications library
  class Library

    # List of default library locations
    DEFAULT_LOCATIONS = begin

      # Use the homedir provided through the environment
      homedir = ENV['HOME']

      # See Apple's support documents as to where libraries can be found
      # - http://support.apple.com/kb/ht1391
      # - http://support.apple.com/kb/ht3847
      [

        # Mac OSX and Windows Vista
        "#{homedir}/Music/iTunes/iTunes Media/Mobile Applications",

        # Windows 7
        "#{homedir}/My Music/iTunes/iTunes Media/Mobile Applications",

        # Windows XP
        "#{homedir}/My Documents/My Music/iTunes/iTunes Media/Mobile Applications",

        # Mac OSX and Windows Vista (prior to iTunes 9)
        "#{homedir}/Music/iTunes/Mobile Applications",

        # Windows 7 (prior to iTunes 9)
        "#{homedir}/My Music/iTunes/Mobile Applications",

        # Windows XP (prior to iTunes 9)
        "#{homedir}/My Documents/My Music/iTunes/Mobile Applications"

      ]
    end

    attr_reader :path

    # Initializes library from given path
    def initialize path
      @path = Pathname.new path
      @path = @path.expand_path unless @path.absolute?

      # Ensure library is a valid directory
      unless @path.directory?
        raise DoesNotExist, "Given path is not a valid mobile applications library: #{@path}"
      end

      @apps = nil
    end

    # Retrieves a list of applications
    def apps
      unless @apps
        load!
      end

      @apps
    end

    # Retrieves a list of valid applications
    def valid_apps
      apps.select { |app| app.valid? }
    end

    # Retrieves a list of outdated applications
    def outdated_apps
      apps.select { |app| app.valid? && app.outdated? }
    end

    # Forcefully loads applications from disk
    def load!
      @apps = []
      @path.children.each do |item|
        if item.file?
          begin
            @apps << App.new(item)
          rescue App::Invalid; end
        end
      end
      self
    end

    # Populates applications' cloud data in bulk
    def clouddata!

      # Collect all application ids, skipping any invalid ones
      ids = apps.collect do |app|
        app.id
      end.compact

      # Queries Apple's iTunes Store API for latest cloud data using undocumented bulk method
      response = Net::HTTP.get('itunes.apple.com', '/lookup?id=' + ids.join(','))
      results = JSON.parse(response)['results']
      results.each do |result|
        if app = get(result['trackId'] || -1)
          app.clouddata = result
        end
      end
    end

    # Searches for application with given id
    def get id
      apps.select do |app|
        app.id == id
      end.first
    end

    # Searches for applications containing given snippet in filename
    def find snippet
      apps.select do |app|
        app.filename.include? snippet
      end
    end

    # Returns the default library (if any) for this system
    def self.default

      # Raise exception if no default library could be found
      path = Dir.glob(DEFAULT_LOCATIONS).first
      unless path
        raise DoesNotExist, 'Could not locate default iTunes mobile applications library'
      end

      # Return an instance of this default library
      Library.new path
    end

    # Raised when a library does not exist
    class DoesNotExist < StandardError; end

  end

end
