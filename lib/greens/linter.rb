require "gherkin3/parser"
require "gherkin3/token_scanner"

module Greens
  # Parse then lint a collection of .feature files for violations
  class Linter
    def initialize(files)
      @files = files
      @results = {}
    end

    def lint
      @files.each { |f| parse_single_file(f) }
    end

    def print_results
      @results.each do |file, violation_data|
        puts "#{file}:#{violation_data[:line]}"
        puts "#{violation_data[:text_of_line]}"
        puts "#{' ' * (violation_data[:column] - 1)}^^^ #{violation_data[:violation]}"
        puts ""
      end

      conclusion = @results.empty? ? "no offenses detected" : "#{@results.count} offense(s) detected"

      puts "#{@files.count} file(s) inspected, #{conclusion}"
    end

    private

    def parse_single_file(fname)
      parser = Gherkin3::Parser.new
      token = Gherkin3::TokenScanner.new(fname)
      parsed = parser.parse(token)

      found = check_for_name_mismatch(parsed, fname)
      # TODO: consider
      # 1) making checks raise a Greens::Violation error class
      # 2) moving checks into their own module when there are a lot of them

      @results[fname] = found if found
    end

    # Returns nil if no violation, or if there is one:
    # { line: 1, column: 1, text_of_line: "Feature: thing", violation: "feature title does not match file name" }
    def check_for_name_mismatch(parsed, path)
      file_name_only = File.basename(path, ".*")
      return if parsed[:name].downcase.gsub(" ", "_") == file_name_only

      res = {}
      res[:line] = parsed[:location][:line]
      res[:column] = parsed[:location][:column]
      res[:text_of_line] = "#{parsed[:keyword]}: #{parsed[:name]}" # TODO: get actual line contents
      res[:violation] = "feature title does not match file name"
      res
    end
  end
end
