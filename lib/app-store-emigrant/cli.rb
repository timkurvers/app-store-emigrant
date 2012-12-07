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

      # Load cloud data in bulk
      library.clouddata!

      # Loop through all applications
      library.apps.each do |app|

        if app.valid?

          # Print their name, version and whether it's outdated
          print app.name + ' @ ' + "v#{app.version}".foreground(app.outdated? ? :red : :green)
          if app.outdated?
            print " (v#{app.cloudversion} available in the cloud)"
          end
        else
          print app.filename + ' is invalid (metadata, id or name missing)'
        end

        puts

      end

    end

  end

end
