require "gherkin3/parser"
require "gherkin3/token_scanner"
require "gherkin3/ast_builder"
require "gherkin3/token_matcher"

require "greener/config_store"
require "greener/formatter_set"

module Greener
  # Parse then lint a collection of .feature files for violations
  class Linter
    def initialize(config_path)
      @config = ConfigStore.new(config_path).resolve
      @results = []
      @formatter_set = FormatterSet.new @config.formatters
    end

    def lint
      @formatter_set.initialized(@config.files)
      @formatter_set.started

      # Here we iterate through a list of files, then iterate through the list of
      # desired checkers, passing each one the filename & parsed AST.
      # This is fine for now, but to speed this up we could refactor this to do a
      # single pass through the file, line-by-line, and flagging violations as
      # they are encountered.
      @config.files.each do |f|
        process_file(f) # TODO: move this to its own class
      end

      @formatter_set.finished @results
    end

    private

    def process_file(fname)
      @formatter_set.file_started

      parser = Gherkin3::Parser.new
      scanner = Gherkin3::TokenScanner.new(fname)
      builder = Gherkin3::AstBuilder.new
      ast = parser.parse(scanner, builder, Gherkin3::TokenMatcher.new)

      violations_in_file = []

      @config.checkers.each do |sc_klass, sc_opts|
        checker = sc_klass.new(ast, fname, sc_opts)
        checker.run
        violations_in_file += checker.violations
        @results += checker.violations
      end

      @formatter_set.file_finished(violations_in_file)
    end
  end
end
