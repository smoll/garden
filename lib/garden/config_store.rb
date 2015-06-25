require "yaml"

require "garden/utils"
require "garden/custom_error"

# Require all scarecrow files here
require "garden/scarecrow/style/feature_name"
require "garden/scarecrow/style/indentation_width"

module Garden
  # Read configs from a user-specified garden.yml or fallback to defaults
  class ConfigStore
    include Utils

    attr_reader :scarecrows, :files

    def initialize(path)
      @path = path
      @default_path = default_path

      @scarecrows = {}
      @files = []
    end

    def resolve
      if @path
        fail CustomError, "No config file found at specified path: #{@path}" unless File.exist? @path
        config = YAML.load_file @path
      end
      defaults = YAML.load_file @default_path

      @all = @path ? defaults.merge(config) : defaults

      validate
      self
    end

    private

    def validate
      set_scarecrows
      set_files

      @all.each do |k, _v|
        fail CustomError, "Unknown option in config file: #{k}" # TODO: print warning instead of fail
      end
    end

    def set_scarecrows
      @all.each do |k, v|
        next unless %w( Style/ Lint/ ).any? { |prefix| k.start_with?(prefix) }
        scarecrow_klass = scarecrow_from_string(k)
        @scarecrows[scarecrow_klass] = v
        @all.delete(k)
      end
    end

    def set_files
      @all.each do |k, v|
        next unless k == "FileList"
        includes = []
        excludes = []
        v["Include"].each { |glob| includes += Dir.glob(glob).select { |e| File.file? e } }
        v["Exclude"].each { |glob| excludes += Dir.glob(glob).select { |e| File.file? e } } if v["Exclude"]
        @files = includes - excludes
        @all.delete(k)
      end
    end

    def default_path
      File.expand_path("../../../config/defaults.yml", __FILE__)
    end
  end
end
