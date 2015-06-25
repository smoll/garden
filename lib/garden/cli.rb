require "thor"

require "garden/linter"

module Garden
  # Main Thor application
  # Subcommands map directly to instance methods in this class.
  # e.g. entering `garden whatever` in your terminal should invoke the App#whatever method
  class CLI < Thor
    desc "lint", "The default task to run when no command is given"
    method_options %w( config -c ) => :string
    def lint
      linter = Linter.new(options[:config])
      linter.lint
      linter.print_results
    end

    default_task :lint
  end
end
