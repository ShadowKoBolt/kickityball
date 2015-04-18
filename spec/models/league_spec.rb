require 'rails_helper'

RSpec.describe League do

  describe ".all", :vcr do
    it "return an array of Leagues" do
      expect(League.all.collect{|l| l.class}.uniq).to eq([League])
    end
  end

end
