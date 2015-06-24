module Garden
  module Scarecrow
    # Base scarecrow class
    class Base
      def initialize(parsed, path)
        @parsed = parsed
        @path = path
      end

      def raw_line(num)
        open(@path).each_line.take(num).last
      end
    end
  end
end
