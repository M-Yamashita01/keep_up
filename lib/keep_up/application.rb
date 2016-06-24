require 'bundler'
require 'open3'

module KeepUp
  class Application
    def initialize(local)
      @local = local
    end

    def bundle(command)
      full_command = "bundle #{command} #{'--local' if @local}"
      puts "Running #{full_command}"
      _out, _err, status = Open3.capture3(full_command)
      status == 0
    end

    def run_or_raise(command)
      puts "Running #{command}"
      success = system command
      raise unless success
    end

    def bundle_up_to_date?
      success = bundle 'outdated'
      if success
        puts 'Bundle up to date!'
      else
        puts 'Bundle is outdated!'
      end
      success
    end

    def run
      # Sanity check
      bundle 'install' or raise
      run_or_raise 'bundle exec rake'

      # Try bundle update
      current_lock_file = Bundler.default_lockfile.read
      if bundle_up_to_date?
        puts 'All done!'
        return
      end
      bundle 'update' or raise
      new_lock_file = Bundler.default_lockfile.read
      if new_lock_file == current_lock_file
        puts 'Update had no effect!'
      else
        run_or_raise 'bundle exec rake'
        if bundle_up_to_date?
          puts 'All done!'
          return
        end
      end

      puts 'More work to do!'

      # create branch
      # git status
      # git commit
      #
    end

  end
end
