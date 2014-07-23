require 'spec_helper'

RSpec.describe CapistranoChangelog::History do

  describe ".generate" do

    it "generates HTML formated changelog" do
      expect{ Nokogiri::HTML(described_class.generate) }.not_to raise_error
    end

  end

end
