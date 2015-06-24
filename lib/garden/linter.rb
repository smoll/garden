require "gherkin3/parser"
require "gherkin3/token_scanner"

require "garden/utils"
require "garden/config_store"
require "garden/scarecrow/style/feature_name"
require "garden/scarecrow/style/indentation_width"

module Garden
  # Parse then lint a collection of .feature files for violations
  class Linter
    include Utils

    def initialize(files, config_path)
      @files = files
      @config = ConfigStore.new(config_path).resolve
      @results = []
    end

    # Here we iterate through a list of files, then iterate through the list of
    # desired scarecrows, passing each one the filename & parsed AST.
    # This is fine for now, but to speed this up we could refactor this to do a
    # single pass through the file, line-by-line, and flagging violations as
    # they are encountered.
    def lint
      @files.each { |f| parse_single_file(f) }
    end

    def print_results
      @results.each do |violation|
        puts "#{violation[:file]}:#{violation[:line]}"
        puts "#{violation[:text_of_line]}"
        puts "#{' ' * (violation[:column] - 1)}^^^ #{violation[:message]}"
        puts ""
      end

      conclusion = @results.empty? ? "no offenses detected" : "#{@results.count} offense(s) detected"

      puts "#{@files.count} file(s) inspected, #{conclusion}"
    end

    private

    def parse_single_file(fname)
      parser = Gherkin3::Parser.new
      scanner = Gherkin3::TokenScanner.new(fname)
      parsed = parser.parse(scanner)

      @config.each do |sc, sc_hash|
        scarecrow = scarecrow_from_string(sc).new(parsed, fname, sc_hash)
        scarecrow.run
        @results += scarecrow.violations
      end
    end
  end
end
