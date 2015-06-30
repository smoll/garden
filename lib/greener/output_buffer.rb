require "stringio"

module Greener
  # Initialize this class to delay output, https://gist.github.com/macek/596007
  class OutputBuffer
    def initialize
      @buffer = StringIO.new
      activate
    end

    def activate
      return if @activated
      self.class.original_stdout = $stdout
      $stdout = @buffer
      @activated = true
    end

    def to_s
      @buffer.rewind
      @buffer.read
    end

    def stop
      self.class.restore_default
    end

    class << self
      attr_accessor :original_stdout

      def restore_default
        $stdout = original_stdout
      end
    end
  end
end
