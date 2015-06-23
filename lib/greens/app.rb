require "thor"

module Greens
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
