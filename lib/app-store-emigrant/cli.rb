require 'rainbow'

module AppStore; end

module AppStore::Emigrant
  
  # Represents the command line interface
  class CLI
    
    # Initializes CLI instance with given arguments
    def initialize args
      
      # Extract the path (if any)
      path, = args
      
      # Use the default library on this system when no path is specified
      library = path ? Library.new(path) : Library.default
      
      # Loop through all applications
      library.apps.each do |app|
        
        # And print their name, version and whether it's outdated
        print app.name + ' @ ' + "v#{app.version}".foreground(app.outdated? ? :red : :green)
        if app.outdated?
          print " (v#{app.cloudversion} available in the cloud)" 
        end
        puts
        
        sleep(0.75)
      end
      
    end
    
  end
  
end
