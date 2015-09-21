require "gherkin3/parser"
require "gherkin3/token_scanner"

module Greener
  # Wrapper around Gherkin3's Parser
  class Parser
    def initialize(feature)
      @feature = feature # filepath or String
    end

    # Return an Abstract Syntax Tree from a feature file
    def ast
      parser = Gherkin3::Parser.new
      scanner = Gherkin3::TokenScanner.new(@feature)
      parser.parse(scanner)
    end
  end
end
