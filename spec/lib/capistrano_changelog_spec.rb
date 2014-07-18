require 'spec_helper'

describe Changelog do

  describe ".root" do
    subject { described_class.root }

    it { should be_a String }
  end

  describe '.templates' do
    subject { described_class.templates }

    it { should be_a String }
    it { should include described_class.root }
  end

end
