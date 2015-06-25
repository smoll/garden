module Garden
  # Useful shared utils
  module Utils
    def scarecrow_from_string(str)
      namespaced = str.gsub("/", "::")
      constantize "Garden::Scarecrow::#{namespaced}"
    rescue NameError
      raise CustomError, "Unknown scarecrow specified: #{str}" # TODO: print warning instead of failing
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
