require 'rails_helper'

RSpec.describe Team do

  vcr_options = {cassette_name: "teams"}

  describe ".all", vcr: vcr_options do
    it "return an array of Leagues" do
      expect(Team.all.collect{|l| l.class}.uniq).to eq([Team])
    end
  end

  describe ".find_by_slug", vcr: vcr_options do
    context "valid slug" do
      it "returns a Team" do
        expect(Team.find_by_slug("aberdeen")).to be_a(Team)
      end
    end

    context "invalid slug" do
      it "raises Team::InvalidSlugException" do
        expect{ Team.find_by_slug("foobar") }.to raise_error(Team::InvalidSlugException)
      end
    end
  end

  describe "#home_fixtures", vcr: {cassette_name: "fixtures"} do
    it "return an array of Fixtures" do
      team = Team.new("aberdeen", "Aberdeen")
      expect(team.home_fixtures.collect{|f| f.class}.uniq).to eq([Fixture])
    end
  end

end
