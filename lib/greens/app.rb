require "thor"
require "greens/linter"

module Greens
  # Main Thor application
  # Subcommands map directly to instance methods in this class.
  # e.g. entering `thor whatever` in your terminal should invoke the App#whatever method
  class App < Thor
    desc "lint", "The default task to run when no command is given"
    def lint
      files = Dir.glob("**/*.feature").select { |e| File.file? e }
      linter = Linter.new(files)
      linter.lint
      linter.print_results
    end

    default_task :lint
  end
end
