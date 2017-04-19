require_relative 'null_filter'

module KeepUp
  # Apply potential updates to a Gemfile.
  class Updater
    attr_reader :bundle, :repository, :version_control, :filter

    def initialize(bundle:, repository:, version_control:, filter: NullFilter.new)
      @bundle = bundle
      @repository = repository
      @version_control = version_control
      @filter = filter
    end

    def run
      direct_updates.each do |update|
        result = bundle.apply_updated_dependency update
        if result
          version_control.commit_changes result
        else
          version_control.revert_changes
        end
      end

      indirect_updates.each do |update|
        result = bundle.apply_updated_dependency update
        if result
          version_control.commit_changes result
        else
          version_control.revert_changes
        end
      end
    end

    def direct_updates
      bundle.direct_dependencies.
        select { |dep| filter.call dep }.
        map { |dep| repository.updated_dependency_for dep }.compact.uniq
    end

    def indirect_updates
      bundle.transitive_dependencies.
        select { |dep| filter.call dep }.
        map { |dep| repository.updated_dependency_for dep }.compact.uniq
    end
  end
end
