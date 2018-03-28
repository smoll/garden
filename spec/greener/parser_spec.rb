RSpec.describe Greener::Parser do
  subject(:parser) { described_class.new("Feature: a thing") }

  describe "#ast" do
    # Copied from https://github.com/cucumber/gherkin3/blob/ab0c2658c27b095953a33d5c205f7723462473ab/ruby/spec/gherkin3/parser_spec.rb#L10-L24
    it "parses a simple feature" do
      ast = subject.ast
      expect(ast).to eq(
        type: :GherkinDocument,
        feature: { type: :Feature, tags: [],
        location: { line: 1, column: 1 }, language: "en",
        keyword: "Feature", name: "a thing", children: [] }, comments: []
      )
    end
  end
end
