require 'spec_helper'
require 'pp'

RSpec.describe Changelog::Git do

  describe ".describe" do
    let(:release) { "v1.2.3-4-g55443322" }

    it "returns last release string" do
      allow(Changelog::Git).to receive(:run).with(Changelog::Git::CMD_VERSION).and_return(release)
      expect(described_class.describe).to eq(release)
    end
  end

  describe ".first_commit" do
    let(:first_commit) { "abc01234xyz" }

    it "returns first commit object" do
      allow(Changelog::Git).to receive(:run).with(Changelog::Git::CMD_FIRST_COMMIT).and_return(first_commit)
      expect(described_class.first_commit).to eq(first_commit)
    end
  end

  describe ".tags" do
    let(:full_output) do
      output =<<OUTPUT
029bb8a07f62d4579b8265cb10e5ab01b8bed880\tv0.0.1\t2013-11-20 10:10:26 +0200
bbc430a085ebff05bf41878336aa688303415f60\tv0.0.2\t2013-11-20 11:04:37 +0200
9c909837862ca121189003a7eec6817a646b2163\tv0.1.0\t2013-11-20 11:07:47 +0200
8bbeaac2b114228d27f8464fe2cd2df15adeb8ce\tv0.1.1\t2013-11-20 12:11:21 +0200
3904d563f7df1332d84606e9b2bf9071ca5552fa\tv0.2.0\t2013-11-21 14:46:33 +0200
5efb66c1f863cb0726e013be4f0d015dafdaa4e1\tv0.2.1\t2013-11-21 15:59:36 +0200
fb5bffcad9d5809d9675687c1c608173db9a1589\tv0.2.2\t2013-11-22 13:11:48 +0200
25fafb66002aef1ba1b3a18015cd3880c1e36694\tv0.3.0\t2013-11-25 15:35:21 +0200
OUTPUT
    end

    it "returns array of hashes" do
      allow(Changelog::Git).to receive(:run).with(Changelog::Git::CMD_TAGS).and_return(full_output)
      expect(described_class.tags).to include({commit: '8bbeaac2b114228d27f8464fe2cd2df15adeb8ce',
                                                title: 'v0.1.1',
                                                datetime: '2013-11-20 12:11:21 +0200'})
    end

    it "returns empty array if no tags were created" do
      allow(Changelog::Git).to receive(:run).with(Changelog::Git::CMD_TAGS).and_return("")
      expect(described_class.tags).to be_empty
    end
  end

end
