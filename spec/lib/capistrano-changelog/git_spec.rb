require 'spec_helper'

RSpec.describe CapistranoChangelog::Git do

  describe ".describe" do
    let(:release) { "v1.2.3-4-g55443322" }

    it "returns last release string" do
      allow(described_class).to receive(:run).with(described_class::CMD_VERSION).and_return(release)
      expect(described_class.describe).to eq(release)
    end
  end

  describe ".first_commit" do
    let(:first_commit) { 'e5eed9f975008ea59ec5d3b47047088949f6fb41' }
    let(:git_log) do
      output =<<OUTPUT
e5eed9f975008ea59ec5d3b47047088949f6fb41\t2013-11-22 13:11:48 +0200\tinitial commit
OUTPUT
    end

    it "returns first commit object" do
      allow(described_class).to receive(:run).with(described_class::CMD_FIRST_COMMIT).and_return(first_commit)
      allow(described_class).to receive(:run).with(described_class::CMD_LOG + first_commit).and_return(git_log)
      expect(described_class.first_commit.commit).to eq(first_commit)
    end
  end

  describe ".last_commit" do
    let(:last_commit) { '8bbeaac2b114228d27f8464fe2cd2df15adeb8ce' }
    let(:git_log) do
      output =<<OUTPUT
8bbeaac2b114228d27f8464fe2cd2df15adeb8ce\t2013-11-22 13:11:48 +0200\tinitial commit
OUTPUT
    end

    it "returns first commit object" do
      allow(described_class).to receive(:run).with(described_class::CMD_LOG + 'HEAD^..HEAD').and_return(git_log)

      expect(described_class.last_commit.commit).to eq(last_commit)
    end
  end

  describe ".releases" do
    let(:full_output) do
      output =<<OUTPUT
029bb8a07f62d4579b8265cb10e5ab01b8bed880\t2013-11-20 10:10:26 +0200\tv0.0.1
bbc430a085ebff05bf41878336aa688303415f60\t2013-11-20 11:04:37 +0200\tv0.0.2
9c909837862ca121189003a7eec6817a646b2163\t2013-11-20 11:07:47 +0200\tv0.1.0
8bbeaac2b114228d27f8464fe2cd2df15adeb8ce\t2013-11-20 12:11:21 +0200\tv0.1.1
3904d563f7df1332d84606e9b2bf9071ca5552fa\t2013-11-21 14:46:33 +0200\tv0.2.0
5efb66c1f863cb0726e013be4f0d015dafdaa4e1\t2013-11-21 15:59:36 +0200\tv0.2.1
fb5bffcad9d5809d9675687c1c608173db9a1589\t2013-11-22 13:11:48 +0200\tv0.2.2
25fafb66002aef1ba1b3a18015cd3880c1e36694\t2013-11-25 15:35:21 +0200\tv0.3.0
OUTPUT
    end

    let(:first_tag) { described_class.releases.first }

    it "returns array of Commit objects" do
      allow(described_class).to receive(:run).with(described_class::CMD_TAGS).and_return(full_output)

      expect(first_tag).to be_a(CapistranoChangelog::Git::Commit)
      expect(first_tag.commit).to eq('029bb8a07f62d4579b8265cb10e5ab01b8bed880')
      expect(first_tag.comment).to eq('v0.0.1')
    end

    it "returns empty array if no tags were created" do
      allow(described_class).to receive(:run).with(described_class::CMD_TAGS).and_return("")
      expect(described_class.releases).to be_empty
    end
  end

  describe ".commits" do
    let(:git_log) do
      output =<<OUTPUT
e5eed9f975008ea59ec5d3b47047088949f6fb41\t2013-11-22 13:11:48 +0200\tupdated html formatting
d4c120c3ecc6abe259489b6ea6a027234422babf\t2013-11-21 15:59:36 +0200\ttime for tags
af94b7cac32054f55d041db3359acb23ccb920aa\t2013-11-21 14:46:33 +0200\tchangelog
OUTPUT
    end

    let(:initial_commit) {  }
    let(:head) {  }

    let(:first_tag)  { CapistranoChangelog::Git::Commit.new({
      commit: '8bbeaac2b114228d27f8464fe2cd2df15adeb8ce',
      datetime: '2013-11-20 12:11:21 +0200',
      title: 'v0.1.1'
    }) }

    let(:second_tag) { CapistranoChangelog::Git::Commit.new({
      commit: 'fb5bffcad9d5809d9675687c1c608173db9a1589',
      datetime: '2013-11-22 13:11:48 +0200',
      title: 'v0.2.2'
    }) }

    let(:predecessor) { CapistranoChangelog::Release.new(first_tag) }
    let(:successor)   { CapistranoChangelog::Release.new(second_tag) }

    it "retrieves list between two commits" do
      allow(described_class).to receive(:run).and_return(git_log)
      expect(described_class.commits(predecessor, successor)).to satisfy { |collection| collection.size == 3 }
    end

    it "retrieves empty list between the same commit" do
      expect(described_class).to_not receive(:run)
      expect(described_class.commits(predecessor, predecessor)).to be_empty
    end

    it "retrieves empty list between wrong sequenve of commits" do
      expect(described_class).to_not receive(:run)
      expect(described_class.commits(successor, predecessor)).to be_empty
    end
  end

end
