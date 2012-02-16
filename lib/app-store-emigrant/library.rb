
require 'pathname'

module AppStore; end

module AppStore::Emigrant
    
  class Library
    
    attr_reader :path, :apps
    
    def initialize path
      
      @path = Pathname.new path
      @path = @path.expand_path unless @path.absolute?
      
      unless @path.directory?
        raise Library::DoesNotExist, "Given path is not a valid library directory: #{@path}"
      end
      
      @apps = []
      
    end
    
    class DoesNotExist < StandardError; end
    
  end
  
end
