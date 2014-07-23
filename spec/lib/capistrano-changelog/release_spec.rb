require 'spec_helper'

RSpec.describe CapistranoChangelog::Release do

  let(:tag) { {commit: 'aabbcczzz', title: 'v0.0.0', datetime: '2013-11-20 12:11:21 +0200' } }

  context "object properties" do

    subject { described_class.new(tag) }

    it "has commit object" do
      expect(subject.commit).to eq('aabbcczzz')
    end

    it "uses tag name" do
      expect(subject.name).to eq('v0.0.0')
    end

    it "uses hash value as value" do
      expect(subject.date.to_i).to eq(Time.mktime(2013,11,20,12,11,21).to_i)
    end

  end

end
