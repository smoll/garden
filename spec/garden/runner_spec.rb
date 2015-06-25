RSpec.describe Garden::Runner do
  let(:argv) { [] }
  let(:dev_null) { File.open(File::NULL, "w") }
  subject(:runner) { described_class.new(argv, dev_null, dev_null, dev_null) }

  describe "#execute!" do
    context "no errors raised" do
      it "exits cleanly" do
        allow(Garden::CLI).to receive(:start)
        expect { subject.execute! }.to terminate.with_code(0)
      end
    end

    context "Garden::CustomError raised by application" do
      it "exits with 1" do
        allow(Garden::CLI).to receive(:start).and_raise(Garden::CustomError)
        expect { runner.execute! }.to terminate.with_code(1)
      end
    end

    context "unhandled exception raised by application" do
      it "exits with 1" do
        allow(Garden::CLI).to receive(:start).and_raise(StandardError)
        expect { runner.execute! }.to terminate.with_code(1)
      end
    end

    context "SystemExit raised by application" do
      let(:random_number) { 7 }
      it "exits with the correct exit code" do
        allow(Garden::CLI).to receive(:start).and_raise(SystemExit.new(random_number))
        expect { runner.execute! }.to terminate.with_code(random_number)
      end
    end
  end
end
