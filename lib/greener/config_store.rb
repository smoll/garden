require "yaml"

require "greener/utils"
require "greener/error"

# Require all checker files here
require "greener/checker/style/feature_name"
require "greener/checker/style/indentation_width"

# And formatters
require "greener/formatter/progress"
require "greener/formatter/simple_text"
require "greener/formatter/summary"

module Greener
  # Read configs from a user-specified greener.yml or fallback to defaults
  class ConfigStore
    include Utils

    attr_reader :checkers, :files, :formatters

    def initialize(path, default_path = nil)
      @path = path
      default_path ||= default_absolute_path
      @default_path = default_path

      @checkers = {}
      @files = []
      @formatters = []
    end

    def resolve
      if @path
        fail Error::Standard, "No config file found at specified path: #{@path}" unless File.exist? @path
        config = load_yml_file @path
      end

      config ||= {}
      defaults = load_yml_file @default_path
      @all = merge_hashes(defaults, config)

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

    # Deep merge, with a few post-merge checks
    def merge_hashes(default, opt)
      result = deep_merge(default, opt)
      # Change nils to empty hashes/arrays so this class isn't littered with #nil? checks
      result["AllCheckers"]["Exclude"] = [] if result["AllCheckers"]["Exclude"].nil?

      result
    end

    def deep_merge(first, second)
      merger = proc { |_key, v1, v2| v1.is_a?(Hash) && v2.is_a?(Hash) ? v1.merge(v2, &merger) : v2 }
      first.merge(second, &merger)
    end

    def validate
      set_formatters
      set_checkers
      set_files

      @all.delete("AllCheckers") if @all["AllCheckers"] && @all["AllCheckers"].empty?

      @all.each do |k, _v|
        $stdout.puts "Unknown option in config file: #{k}".color(:red)
      end
    end

    def set_formatters
      formatters = @all["AllCheckers"]["Formatters"].uniq.compact
      # Ensure "Summary" formatter is in last position
      if formatters.include?("Summary")
        formatters << formatters.delete("Summary")
      else
        formatters << "Summary"
      end
      formatters.each do |f_string|
        formatter_class = formatter_from_string(f_string)
        next unless formatter_class # Don't add to @formatters if nil
        @formatters << formatter_class
      end

      @all["AllCheckers"].delete "Formatters"
    end

    def set_checkers
      @all.each do |k, v|
        next unless %w( Style/ Lint/ ).any? { |prefix| k.start_with?(prefix) }
        checker_class = checker_from_string(k)
        @checkers[checker_class] = v if checker_class
        @all.delete(k)
      end
    end

    def set_files
      includes = []
      excludes = []

      @all["AllCheckers"]["Include"].each { |glob| includes += files_matching_glob(glob) }
      @all["AllCheckers"].delete "Include"

      @all["AllCheckers"]["Exclude"].each { |glob| excludes += files_matching_glob(glob) }
      @all["AllCheckers"].delete "Exclude"

      @files = includes.uniq - excludes.uniq
    end

    def default_absolute_path
      File.expand_path("../../../config/defaults.yml", __FILE__)
    end
  end
end
