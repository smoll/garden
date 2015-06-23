module Greens
  # Parse and lint .feature file as plain text file
  # TODO: use the Gherkin3 parser when this gets more complex
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
        puts "#{file}:#{violation_data[:lineno]}"
        puts "#{violation_data[:line]}"
        puts "^^^ #{violation_data[:violation]}"
        puts ""
      end

      conclusion = @results.empty? ? "no offenses detected" : "#{@results.count} offense(s) detected"

      puts "#{@files.count} file(s) inspected, #{conclusion}"
    end

    private

    def parse_single_file(fname)
      File.open(fname).each_line.with_index do |line, lineno| # lineno is 0-indexed
        found = check_for_violations(line, fname)
        next unless found
        @results[fname] = { line: line, lineno: lineno + 1, violation: found }
      end
    end

    def check_for_violations(str, path)
      file_name_only = File.basename(path, ".*")
      return unless str.strip.start_with? "Feature:"

      formatted = str.sub("Feature:", "").strip.sub(" ", "_").downcase
      return "feature title does not match file name" if formatted != file_name_only
    end
  end
end
