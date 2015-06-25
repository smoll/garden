require "gherkin3/parser"
require "gherkin3/token_scanner"

require "greener/config_store"

module Greener
  # Parse then lint a collection of .feature files for violations
  class Linter
    def initialize(config_path)
      @config = ConfigStore.new(config_path).resolve
      @results = []
    end

    # Here we iterate through a list of files, then iterate through the list of
    # desired checkers, passing each one the filename & parsed AST.
    # This is fine for now, but to speed this up we could refactor this to do a
    # single pass through the file, line-by-line, and flagging violations as
    # they are encountered.
    def lint
      @config.files.each { |f| parse_single_file(f) }
    end

    def print_results
      @results.each do |violation|
        puts "#{violation[:file]}:#{violation[:line]}"
        puts "#{violation[:text_of_line]}"
        puts "#{' ' * (violation[:column] - 1)}^^^ #{violation[:message]}"
        puts ""
      end

      conclusion = @results.empty? ? "no offenses detected" : "#{@results.count} offense(s) detected"

      puts "#{@config.files.count} file(s) inspected, #{conclusion}"
    end

    private

    def parse_single_file(fname)
      parser = Gherkin3::Parser.new
      scanner = Gherkin3::TokenScanner.new(fname)
      parsed = parser.parse(scanner)

      @config.checkers.each do |sc_klass, sc_opts|
        checker = sc_klass.new(parsed, fname, sc_opts)
        checker.run
        @results += checker.violations
      end
    end
  end
end
