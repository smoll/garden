require "greener/formatter/base_formatter"

module Greener
  module Formatter
    # Prints violation info that includes file, line number, text of the line, and message
    class SimpleText < BaseFormatter
      def finished(violations)
        violations.each do |violation|
          puts "#{violation[:file]}:#{violation[:line]}"
          puts "#{violation[:text_of_line]}"
          puts "#{' ' * (violation[:column] - 1)}^^^ #{violation[:message]}"
          puts ""
        end
      end
    end
  end
end
