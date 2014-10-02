require 'spec_helper'

RSpec.describe CapistranoChangelog::History do

  let(:initial) { CapistranoChangelog::Git::Commit.new(commit: 'theveryfirstcommit', datetime: (Time.now - 30).to_s, comment: '1') }
  let(:first)   { CapistranoChangelog::Git::Commit.new(commit: 'firstcommit123',     datetime: (Time.now - 10).to_s, comment: '2') }
  let(:second)  { CapistranoChangelog::Git::Commit.new(commit: 'secondcommit231',    datetime: (Time.now     ).to_s, comment: '3') }
  let(:third)   { CapistranoChangelog::Git::Commit.new(commit: 'thirdcommit321',     datetime: (Time.now + 10).to_s, comment: '4') }
  let(:head)    { CapistranoChangelog::Git::Commit.new(commit: 'theverylastcommit',  datetime: (Time.now + 30).to_s, comment: '5') }
  let(:collection) { [first, second, third] }

  before do
    allow(CapistranoChangelog::Git).to receive(:last_commit).and_return(head)
    allow(CapistranoChangelog::Git).to receive(:first_commit).and_return(initial)
  end

  subject { described_class.new }

  describe ".next_to" do
    it "have to return next release from history if exists" do
      allow(CapistranoChangelog::Release).to receive(:all).and_return(collection)
      expect(subject.next_to(first)).to eq(second)
    end

    it "have to return HEAD if next release does not exists" do
      allow(CapistranoChangelog::Release).to receive(:all).and_return(collection)
      expect(subject.next_to(third).commit).to eq('theverylastcommit')
    end
  end

  describe ".prev_to" do
    it "have to return prev release from history if exists" do
      allow(CapistranoChangelog::Release).to receive(:all).and_return(collection)
      expect(subject.prev_to(second)).to eq(first)
    end

    it "have to return FIRST if prev release does not exists" do
      allow(CapistranoChangelog::Release).to receive(:all).and_return(collection)
      expect(subject.prev_to(first).commit).to eq(initial.commit)
    end
  end

  describe ".generate", skip: true do
    it "generates HTML formated changelog" do
      expect{ Nokogiri::HTML(described_class.new.generate) }.not_to raise_error
    end
  end

end
