# encoding: utf-8

require 'rainbow'
require 'thor'

module AppStore; end

module AppStore::Emigrant

  # Represents the command line interface
  class CLI < Thor

    desc 'scan [LIBRARY PATH]', 'Scans an iTunes library and reports which of its mobile applications are out of date'
    method_option :clear_cache, :type => :boolean, :default => false, :aliases => '-c', :desc => 'Clears application cache prior to scanning'
    def scan path = nil

      # Ensure all output is immediately flushed
      $stdout.sync = true

      # Use the default library on this system when no path is specified
      library = path ? Library.new(path) : Library.default

      # Clear cache if requested
      if options[:clear_cache]
        Cache.clear!
      end

      # Verify cache integrity
      puts 'Verifying cache integrity..'

      # Forcefully cache metadata for each application that is not yet cached
      library.apps.each do |app|

        unless app.cached?
          begin
            app.cache!
            puts " + #{app.name} v#{app.version}"
          rescue App::Invalid => e
            puts " ! Cannot cache #{app.filename}: #{e.message}".foreground(:red).bright
          end
        end

      end

      # Print cache statistics
      puts "Done. Currently caching #{Cache.count} applications on your system."

      puts

      # Since all apps are cached, load cloud data in bulk
      library.clouddata!

      # Print library statistics
      puts "Your library contains #{library.valid_apps.length} valid applications, of which #{library.outdated_apps.length} are outdated:"

      # Loop through all applications
      library.apps.each do |app|

        if app.valid?

          # Generate color-coded version
          version = "v#{app.version}".foreground(app.outdated? ? :red : :green)
          if app.outdated?
            version = version.bright
          end

          # Print application name, version and whether it's outdated
          print " · #{app.name} #{version}"
          if app.outdated?
            print " · v#{app.cloudversion} available".foreground(:white)
          end

          puts
        else
          puts " ! #{app.filename} is invalid (metadata, id or name missing)".foreground(:red).bright
        end

      end

    end

    desc 'version', 'Prints version information'
    def version
      puts "App Store Emigrant v#{AppStore::Emigrant::VERSION}"
    end

  end

end
