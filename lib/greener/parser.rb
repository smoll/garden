require "gherkin/parser"
require "gherkin/token_scanner"

module Greener
  # Wrapper around Gherkin3's Parser
  class Parser
    def initialize(feature)
      @feature = feature # String containing file contents
    end

    # Return an Abstract Syntax Tree from a feature file
    def ast
      parser = Gherkin::Parser.new
      if @feature.include?("Feature:")
        parser.parse(Gherkin::TokenScanner.new(@feature))
      else
        parser.parse(Gherkin::TokenScanner.new(File.read(@feature)))[:feature]
      end
    end
  end
end
