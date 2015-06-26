module Greener
  class CustomError < StandardError; end

  module Error
    class LintFailed < Greener::CustomError; end
  end
end
