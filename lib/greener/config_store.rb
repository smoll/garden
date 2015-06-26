require "yaml"

require "greener/utils"
require "greener/custom_error"

# Require all checker files here
require "greener/checker/style/feature_name"
require "greener/checker/style/indentation_width"

module Greener
  # Read configs from a user-specified greener.yml or fallback to defaults
  class ConfigStore
    include Utils

    attr_reader :checkers, :files

    def initialize(path, default_path = nil)
      @path = path
      default_path ||= default_absolute_path
      @default_path = default_path

      @checkers = {}
      @files = []
    end

    def resolve
      if @path
        fail CustomError, "No config file found at specified path: #{@path}" unless File.exist? @path
        config = load_yml_file @path
      end
      defaults = load_yml_file @default_path

      @all = @path ? defaults.merge(config) : defaults

      validate
      self
    end

    # Stub-able methods
    def load_yml_file(path)
      YAML.load_file(path)
    end

    def files_matching_glob(glob)
      Dir.glob(glob).select { |e| File.file? e }
    end

    private

    def validate
      set_checkers
      set_files

      @all.each do |k, _v|
        fail CustomError, "Unknown option in config file: #{k}" # TODO: print warning instead of fail
      end
    end

    def set_checkers
      @all.each do |k, v|
        next unless %w( Style/ Lint/ ).any? { |prefix| k.start_with?(prefix) }
        checker_klass = checker_from_string(k)
        @checkers[checker_klass] = v
        @all.delete(k)
      end
    end

    def set_files
      if @all["FileList"].nil?
        # Default to all .feature files recursively
        return @files = files_matching_glob("**/*.feature")
      end

      @all.each do |k, v|
        next unless k == "FileList"
        discover_files(v)
        @all.delete(k)
      end
    end

    def discover_files(hash)
      includes = []
      excludes = []

      hash["Include"].each { |glob| includes += files_matching_glob(glob) } if hash["Include"]
      hash["Exclude"].each { |glob| excludes += files_matching_glob(glob) } if hash["Exclude"]
      @files = (includes - excludes).uniq
    end

    def default_absolute_path
      File.expand_path("../../../config/defaults.yml", __FILE__)
    end
  end
end
