require "greener/formatter/base_formatter"

module Greener
  module Formatter
    # Print progress in real-time
    class Progress < BaseFormatter
      def file_finished(violations)
        if violations.empty?
          print ".".color(:green)
        else
          print "F".color(:red)
        end
      end

      def finished(_violations)
        puts ""
        puts ""
      end
    end
  end
end
