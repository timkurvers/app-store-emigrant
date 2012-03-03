require 'pathname'

module AppStore; end

module AppStore::Emigrant
  
  # Represents a single iTunes mobile applications library
  class Library
    
    attr_reader :path
    
    # Initializes library from given path
    def initialize path
      @path = Pathname.new path
      @path = @path.expand_path unless @path.absolute?
      
      # Ensure library is a valid directory
      unless @path.directory?
        raise DoesNotExist, "Given path is not a valid library directory: #{@path}"
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
    
    # Searches for applications containing given snippet in filename
    def find snippet
      apps.select do |app|
        app.filename.include? snippet
      end
    end
    
    # Returns the default library (if any) for this system
    # See Apple's support document (http://support.apple.com/kb/ht1391) as to where libraries can be found
    def self.default
      
      # Use the homedir provided through the environment
      homedir = ENV['HOME']
      
      # List all locations
      locations = [
        
        # Mac OSX and Windows Vista
        "#{homedir}/Music/iTunes/iTunes Media/Mobile Applications/",
        
        # Windows 7
        "#{homedir}/My Music/iTunes/iTunes Media/Mobile Applications/",
        
        # Windows XP
        "#{homedir}/My Documents/My Music/iTunes/iTunes Media/Mobile Applications/"
      ]
      
      # Raise exception if no default library could be found
      path = Dir.glob(locations).first
      unless path
        raise DoesNotExist, 'Could not locate default iTunes library'
      end
      
      # Return an instance of this default library
      Library.new path
    end
    
    # Raised when a library does not exist
    class DoesNotExist < StandardError; end
    
  end
  
end
