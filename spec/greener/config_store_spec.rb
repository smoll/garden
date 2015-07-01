# Create real temp files, to avoid having to mock out implementation specifics like:
# allow(File).to receive(:exist?).and_return(true)
RSpec.describe Greener::ConfigStore, type: :aruba do
  let(:partial_path) { "real/override.yml" }

  before(:each) do
    write_file "rspec_aruba.feature", "Feature: Using the Aruba API in RSpec"
    write_file partial_path, overrider
  end

  subject(:store) { described_class.new("tmp/aruba/#{partial_path}") }

  describe "#resolve" do
    context "happy path" do
      let(:overrider) do
        <<-YML.gsub(/^\s+\|/, "")
          |AllCheckers:
          |  Include:
          |    - "tmp/aruba/*.feature"
          |
          |Style/FeatureName:
          |  Enabled: true
        YML
      end

      # Explicitly pass nil so it uses defaults.yml only
      let(:default_checkers) { described_class.new(nil).resolve.checkers }

      it "returns the checker specified in a real file in #checkers" do
        expect(subject.resolve.checkers).to eq(default_checkers)
      end

      it "returns a list of real files in #files" do
        expect(subject.resolve.files).to eq(["tmp/aruba/rspec_aruba.feature"])
      end
    end

    context "exclude files" do
      let(:overrider) do
        <<-YML.gsub(/^\s+\|/, "")
          |AllCheckers:
          |  Exclude:
          |    - "**/*.feature"
        YML
      end

      it "returns no files in #files" do
        expect(subject.resolve.files).to eq([])
      end
    end

    context "invalid config file" do
      let(:overrider) do
        <<-YML.gsub(/^\s+\|/, "")
          |CompletelyInvalid:
          |  Enabled: true
        YML
      end

      it "outputs a warning" do
        expect { subject.resolve }.to output(/Unknown option/).to_stdout
      end
    end

    context "nonexistent checker in config file" do
      let(:overrider) do
        <<-YML.gsub(/^\s+\|/, "")
          |Style/FakeChecker:
          |  Enabled: true
        YML
      end

      it "outputs a warning" do
        expect { subject.resolve }.to output(/Unknown checker/).to_stdout
      end
    end
  end
end
