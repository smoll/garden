RSpec.describe Greener::ConfigStore do
  subject(:store) { described_class.new("path/to/config.yml", "path/to/default.yml") }

  describe "#initialize" do
    it "doesn't raise an exception" do
      expect { subject }.not_to raise_exception
    end
  end

  describe "#resolve" do
    let(:default_config) do
      { "Style/FeatureName" => { "Enabled" => true }, "Style/IndentationWidth" => { "Enabled" => true, "Width" => 2 } }
    end

    let(:overriding_config) do
      {
        "Style/IndentationWidth" => { "Enabled" => true, "Width" => 4 },
        "AllCheckers" => { "Include" => ["fake/glob/*.feature"] }
      }
    end

    let(:expected_checkers) do
      {
        Greener::Checker::Style::FeatureName => { "Enabled" => true },
        Greener::Checker::Style::IndentationWidth => { "Enabled" => true, "Width" => 4 }
      }
    end

    let(:dummy_glob) { "fake/glob/*.feature" }
    let(:dummy_files) { ["dummy.feature"] }

    before(:each) do
      allow(File).to receive(:exist?).and_return(true)
      allow(subject).to receive(:load_yml_file).with("path/to/config.yml").and_return(overriding_config)
      allow(subject).to receive(:load_yml_file).with("path/to/default.yml").and_return(default_config)
      allow(subject).to receive(:files_matching_glob).with(dummy_glob).and_return(dummy_files)
    end

    it "returns the instance" do
      expect(subject.resolve).to be_a Greener::ConfigStore
    end

    it "returns checkers in the #checkers attribute" do
      expect(subject.resolve.checkers).to eq(expected_checkers)
    end

    it "returns globbed files in the #files attribute" do
      expect(subject.resolve.files).to eq(dummy_files)
    end
  end
end

# Create real temp files, to avoid having to mock out implementation specifics like:
# allow(File).to receive(:exist?).and_return(true)
RSpec.describe Greener::ConfigStore, type: :aruba do
  before(:each) do
    write_file("real/default.yml", "Style/FeatureName:\n  Enabled: false")
    write_file("rspec_aruba.feature", "Feature: Using the Aruba API in RSpec")
  end

  describe "#resolve" do
    context "happy path" do
      before(:each) { write_file("real/happy.yml", "Style/FeatureName:\n  Enabled: true") }
      subject(:store) { described_class.new("tmp/aruba/real/happy.yml", "tmp/aruba/real/default.yml") }

      let(:expected_checkers) do
        { Greener::Checker::Style::FeatureName => { "Enabled" => true } }
      end

      it "returns the checker specified in a real file in #checkers" do
        expect(subject.resolve.checkers).to eq(expected_checkers)
      end

      it "returns a list of real files in #files" do
        expect(subject.resolve.files).to include("tmp/aruba/rspec_aruba.feature")
      end
    end

    context "exclude files" do
      before(:each) { write_file("real/ignore_all.yml", "AllCheckers:\n  Exclude:\n    - '**/*.feature'") }
      subject(:store) { described_class.new("tmp/aruba/real/ignore_all.yml", "tmp/aruba/real/default.yml") }

      it "returns no files in #files" do
        expect(subject.resolve.files).to eq([])
      end
    end

    context "invalid config file" do
      before(:each) { write_file("real/invalid_keys.yml", "CompletelyInvalid:\n  Enabled: true") }
      subject(:store) { described_class.new("tmp/aruba/real/invalid_keys.yml", "tmp/aruba/real/default.yml") }

      it "raises an error" do
        expect { subject.resolve }.to raise_error(Greener::CustomError, /Unknown option/)
      end
    end

    context "nonexistent checker in config file" do
      before(:each) { write_file("real/invalid_checker.yml", "Style/FakeChecker:\n  Enabled: true") }
      subject(:store) { described_class.new("tmp/aruba/real/invalid_checker.yml", "tmp/aruba/real/default.yml") }

      it "raises an error" do
        expect { subject.resolve }.to raise_error(Greener::CustomError, /Unknown checker/)
      end
    end
  end
end
