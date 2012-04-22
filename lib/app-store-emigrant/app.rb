require 'cfpropertylist'
require 'json'
require 'net/http'
require 'pathname'
require 'zip/zip'
require 'zip/zipfilesystem'

module AppStore; end

module AppStore::Emigrant
  
  # Represents a single iTunes mobile application
  class App
    
    # List of valid extensions for an application
    VALID_EXTENSIONS = [
      '.ipa'
    ]
    
    # Regular expression to match a version number in filenames
    FILENAME_VERSION_REGEX = Regexp.new('([0-9.]+)(?:' + VALID_EXTENSIONS.join('|').gsub!('.', '\.') + ')')
    
    attr_reader :path
    
    # Initializes application from given path
    def initialize path
      @path = Pathname.new path
      @path = @path.expand_path unless @path.absolute?
      
      # Ensure application exists
      unless @path.file?
        raise DoesNotExist, "Given path is not a valid application: #{@path}"
      end
      
      # Ensure application has valid extension
      unless VALID_EXTENSIONS.include? @path.extname
        raise Invalid, "Given application does not have a valid extension: #{@path}"
      end
      
      @metadata = nil
      @clouddata = nil
    end
    
    # Filename of this application (including extension)
    def filename
      unless @filename
        @filename = @path.basename().to_s
      end
      
      @filename
    end
    
    # Unique application id
    def id
      metadata['itemId'] rescue nil
    end
    
    # Name of this application
    def name
      metadata['itemName'] rescue nil
    end
    
    # Whether this application is valid
    def valid?
      metadata rescue false
    end
    
    # Version of this application
    def version
      unless @version
        
        # Extract version information (if available)
        @version = metadata['bundleShortVersionString'] || metadata['bundleVersion'] rescue nil
        
        # Otherwise, use the filename
        unless @version
          @version = filename[FILENAME_VERSION_REGEX, 1]
        end
        
      end
      
      @version
    end
    
    # Lazily loads local metadata for this application from its iTunesMetadata.plist
    def metadata
      unless @metadata
        begin
          Zip::ZipFile.open(@path) do |zip|
            data = zip.file.read('iTunesMetadata.plist')
            plist = CFPropertyList::List.new(:data => data)
            @metadata = CFPropertyList.native_types(plist.value)
          end
        rescue Zip::ZipError => e
          raise Invalid, e.message
        end
      end
      
      @metadata
    end
    
    # Lazily queries Apple's iTunes Store API for latest cloud data
    # Note: Clouddata may be nil if the application was removed from the store
    def clouddata
      unless @clouddata
        response = Net::HTTP.get('itunes.apple.com', '/lookup?id=' + id.to_s)
        @clouddata = JSON.parse(response)['results'].first
      end
      
      @clouddata
    end
    
    # Version available in the cloud
    def cloudversion
      clouddata && clouddata['version']
    end
    
    # Whether this application is outdated
    def outdated?
      return cloudversion && version != cloudversion
    end
  
    # Raised when an application does not exist
    class DoesNotExist < StandardError; end
  
    # Raised when an application is invalid (e.g non-valid extension)
    class Invalid < StandardError; end
    
  end
  
end
