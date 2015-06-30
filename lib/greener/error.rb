module Greener
  module Error
    class Standard < StandardError; end

    class LintFailed < Standard; end
  end
end
