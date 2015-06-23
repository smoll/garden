require "thor"

module Greens
  # Main Thor application
  # Subcommands map directly to instance methods in this class.
  # e.g. entering `thor whatever` in your terminal should invoke the App#whatever method
  class App < Thor
    desc "lint", "The default task to run when no command is given"
    def lint
      require "find"
      puts "PWD: #{Dir.pwd}"
      @files = Dir.glob("**/*.feature").select { |e| File.file? e }
      puts "files: #{@files}"
    end

    default_task :lint
  end
end
