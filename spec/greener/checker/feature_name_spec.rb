RSpec.describe Greener::Checker::Style::FeatureName do
  let(:ast) do
    {
      type: :Feature,
      tags: [],
      location: { line: 1, column: 1 },
      language: "en",
      keyword: "Feature",
      name: "test!",
      scenarioDefinitions: [],
      comments: []
    }
  end
  let(:config) { { "Enabled" => true, "AllowPunctuation" => false, "EnforceTitleCase" => true } }
  subject(:checker) { described_class.new(ast, "test.feature", config) }

  describe "#run" do
    context "when there are 2 violations" do
      it "logs 2 violations" do
        expect(subject).to receive(:log_violation).twice
        subject.run
      end
    end

    context "when checker is completely disabled" do
      let(:config) { { "Enabled" => false, "AllowPunctuation" => false, "EnforceTitleCase" => true } }

      it "doesn't log a violation" do
        expect(subject).not_to receive(:log_violation)
        subject.run
      end
    end

    context "when ignoring the punctuation violation" do
      let(:config) { { "Enabled" => true, "AllowPunctuation" => true, "EnforceTitleCase" => true } }

      it "logs only one violation" do
        expect(subject).to receive(:log_violation).once
        subject.run
      end
    end

    context "when ignoring the title case violation" do
      let(:config) { { "Enabled" => true, "AllowPunctuation" => false, "EnforceTitleCase" => false } }

      it "logs only one violation" do
        expect(subject).to receive(:log_violation).once
        subject.run
      end
    end

    context "when ignoring both violations" do
      let(:config) { { "Enabled" => true, "AllowPunctuation" => true, "EnforceTitleCase" => false } }

      it "doesn't log a violation" do
        expect(subject).not_to receive(:log_violation)
        subject.run
      end
    end
  end
end
