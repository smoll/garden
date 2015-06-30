module Greener
  module Formatter
    # Abstract base class for formatter, implements all public API methods.
    #
    # ## Method Invocation Order
    #
    # For example, when Greener inspects 2 files,
    # the invocation order should be like this:
    #
    # * `#initialize`
    # * `#started`
    # * `#file_started`
    # * `#file_finished`
    # * `#file_started`
    # * `#file_finished`
    # * `#finished`
    class BaseFormatter
      def initialize(files)
        @files = files
      end

      def started
      end

      def file_started
      end

      def file_finished(_violations)
      end

      def finished(_violations)
      end
    end
  end
end
