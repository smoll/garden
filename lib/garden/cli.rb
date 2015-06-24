require "thor"
require "garden/linter"
require "garden/custom_error"

module Garden
  # Main Thor application
  # Subcommands map directly to instance methods in this class.
  # e.g. entering `garden whatever` in your terminal should invoke the App#whatever method
  class CLI < Thor
    desc "lint", "The default task to run when no command is given"
    method_options %w( config -c ) => :string
    def lint
      files = Dir.glob("**/*.feature").select { |e| File.file? e }
      linter = Linter.new(files, options[:config])
      linter.lint
      linter.print_results
    end

    default_task :lint
  end
end
