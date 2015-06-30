require "greener/formatter/base_formatter"

module Greener
  module Formatter
    # Prints summary line, e.g. "10 file(s) inspected, no offenses detected"
    class Summary < BaseFormatter
      def finished(violations)
        conclusion = violations.empty? ? "no offenses detected" : "#{violations.count} offense(s) detected"

        res = "#{@files.count} file(s) inspected, #{conclusion}"
        return puts(res) if violations.empty?
        fail Greener::Error::LintFailed, res
      end
    end
  end
end
