require "yaml"

module Garden
  # Read configs from a user-specified garden.yml or fallback to defaults
  class ConfigStore
    include Utils

    def initialize(path)
      @path = path
      @default_path = default_path
    end

    def resolve
      if @path
        fail CustomError, "No config file found at specified path: #{@path}" unless File.exist? @path
        config = YAML.load_file @path
      end
      defaults = YAML.load_file @default_path

      resolved = @path ? defaults.merge(config) : defaults
      resolved.each { |k, _v| scarecrow_from_string(k) }
      resolved
    end

    private

    def default_path
      File.expand_path("../../../config/defaults.yml", __FILE__)
    end
  end
end
