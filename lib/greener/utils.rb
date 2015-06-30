module Greener
  # Useful shared utils
  module Utils
    def checker_from_string(str)
      namespaced = str.gsub("/", "::")
      constantize "Greener::Checker::#{namespaced}"
    rescue NameError
      raise Error::Standard, "Unknown checker specified: #{str}" # TODO: print warning instead of failing
    end

    def formatter_from_string(str)
      constantize "Greener::Formatter::#{str}"
    rescue NameError
      raise Error::Standard, "Unknown formatter specified: #{str}" # TODO: print warning instead of failing
    end

    private

    # Borrowed from Rails
    def constantize(camel_cased_word)
      names = camel_cased_word.split("::")
      names.shift if names.empty? || names.first.empty?

      constant = Object
      names.each do |name|
        constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
      end
      constant
    end
  end
end
