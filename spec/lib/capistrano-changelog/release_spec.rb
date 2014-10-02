require 'spec_helper'

RSpec.describe CapistranoChangelog::Release do

  let(:first_tag)  { CapistranoChangelog::Git::Commit.new commit: 'aabbcczz1', title: 'v0.0.1', datetime: '2013-11-21 10:10:10 +0200' }
  let(:second_tag) { CapistranoChangelog::Git::Commit.new commit: 'aabbcczz2', title: 'v0.0.2', datetime: '2013-11-22 10:10:10 +0200' }
  let(:last_tag)   { CapistranoChangelog::Git::Commit.new commit: 'aabbcczz3', title: 'v0.0.3', datetime: '2013-11-23 10:10:10 +0200' }

  context "object properties" do

    let(:tag) { first_tag }

    subject { described_class.new(tag) }

    it "has commit object" do
      expect(subject.commit).to eq('aabbcczz1')
    end

    it "uses tag name" do
      expect(subject.title).to eq('v0.0.1')
    end

    it "uses hash value as value" do
      expect(subject.date).to eq(Time.utc(2013,11,21,8,10,10))
    end

  end


  context "comparable" do

    let(:one)   { described_class.new(first_tag) }
    let(:two)   { described_class.new(second_tag) }
    let(:three) { described_class.new(last_tag) }

    it "have to be equal" do
      expect(one <=> one).to eq(0)
    end

    it "have to be lower" do
      expect(one <=> two).to eq(-1)
    end

    it "have to be greater" do
      expect(three <=> two).to eq(1)
    end

    it "have to be sortable" do
      expect([one, three, two].sort).to eq([one, two, three])
    end

    it "have to be reversable" do
      expect([one, two, three].reverse).to eq([three, two, one])
    end

  end


  describe ".stories" do



  end

end
