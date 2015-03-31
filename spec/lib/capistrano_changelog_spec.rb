require 'spec_helper'

describe CapistranoChangelog do

  describe ".root" do
    subject { described_class.root }

    it { should be_a String }
  end

  describe '.templates' do
    subject { described_class.templates }

    it { should be_a String }
    it { should include described_class.root }
  end

  describe '.pivotal_tracker' do
    subject { described_class.pivotal_tracker }

    before { ENV['PIVOTAL_TOKEN'] = nil }

    it { should be_nil }

    context "env variable is defined" do
      let(:token) { 'test123456' }

      before { ENV['PIVOTAL_TOKEN'] = token }

      it { should == token }
    end
  end

end
