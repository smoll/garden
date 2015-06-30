module Greener
  # A set of Greener::Formatter::SomeFormatter objects
  class FormatterSet
    def initialize(formatters)
      @formatters = formatters
    end

    # Note the "d"
    def initialized(*args)
      @formatters = @formatters.map { |formatter| formatter.new(*args) }
    end

    # All these instance methods have the same method signature as those of the Formatter classes
    [:started, :file_started, :file_finished, :finished].each do |method_name|
      define_method method_name do |*args|
        @formatters.each { |formatter| formatter.send(method_name, *args) }
      end
    end
  end
end
