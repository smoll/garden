module Greener
  module Checker
    # Base checker class
    class Base
      attr_reader :violations

      def initialize(parsed, path, config)
        @parsed = parsed
        @path = path
        @config = config

        @violations = []
      end

      # Method invoked when a checker is applied to a file
      def run
      end

      # Read the violation message text set in the checker subclass
      def message
        self.class::MSG
      end

      # Adds violation data to the @violations array
      def log_violation(line, col, raw_txt = nil, msg = nil)
        # Set defaults for last 2 params if not overridden
        raw_txt ||= raw_line(line)
        msg ||= message

        violation = {}
        violation[:file] = @path
        violation[:line] = line
        violation[:column] = col
        violation[:text_of_line] = raw_txt
        violation[:message] = msg

        @violations << violation
      end

      # For readability in checker subclasses
      def feature
        @parsed
      end

      # Given a num, returns the full text corresponding to that line number in the file
      def raw_line(num)
        open(@path).each_line.take(num).last
      end
    end
  end
end
