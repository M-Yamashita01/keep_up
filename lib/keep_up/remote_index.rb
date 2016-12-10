module KeepUp
  # Searches possibly remote gem index to find potential dependency updates.
  class RemoteIndex
    def search(dependency)
      index.search(Bundler::Dependency.new(dependency.name, nil))
    end

    private

    def definition
      @definition ||=
        Bundler::Definition.build('Gemfile', 'Gemfile.lock', true).tap(&:resolve_remotely!)
    end

    def index
      @index ||= definition.index
    end
  end
end
