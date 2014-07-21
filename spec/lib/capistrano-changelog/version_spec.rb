require 'spec_helper'

RSpec.describe CapistranoChangelog::Version do

  let(:version) { 'x.y.z-andsomehash' }

  describe ".generate" do
    it "generates JSON string" do
      expect{ JSON.parse(described_class.generate) }.not_to raise_error
    end

    context "JSON content" do
      let(:time) { Time.mktime(2014,01,01) }

      before do
        allow(Changelog::Git).to receive(:describe).and_return(version)
        allow(Time).to receive(:now).and_return(time)
      end

      subject { JSON.parse(described_class.generate) }

      it "contains version string" do
        expect(subject).to include({'version' => version})
      end

      it "contains UNIX timestamp" do
        expect(subject).to include({'ts' => time.to_i})
      end

      context "restart flag" do
        it "returns true by default" do
          allow(ENV).to receive(:fetch).with('RESTART', 'true').and_return('true')
          expect(subject).to include({'restart' => true})
        end

        it "returns false if environment variable exists" do
          allow(ENV).to receive(:fetch).with('RESTART', 'true').and_return('any value or false')
          expect(subject).to include({'restart' => false})
        end
      end
    end
  end

end
