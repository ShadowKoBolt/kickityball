require 'rails_helper'

RSpec.describe Fixture do
  describe ".find_all_by_team_slug", vcr: {cassette_name: "fixtures"} do
    context "with valid team slug" do
      it "returns an array of Fixtures" do
        expect(Fixture.find_all_by_team_slug("aberdeen").collect{|f| f.class}.uniq).to eq([Fixture])
      end
    end
    
    context "with invalid team slug" do
      it "raises a Team::InvalidSlugException" do
        expect{ Fixture.find_all_by_team_slug("foobar") }.to raise_error(Team::InvalidSlugException)
      end
    end
  end

  describe "#name" do
    subject { Fixture.new(nil, nil, nil, "Foo", "Bar") }
    it "starts with the home team" do
      expect(subject.name).to match(/^Foo /)
    end

    it "ends with the away team" do
      expect(subject.name).to match(/ Bar$/)
    end
  end

  describe "#datetime" do
    subject { Fixture.new("2015", "Sat 18 Apr", "15:00", nil, nil) }
    it "should be Saturday the 18th of April at 3PM" do
      expect(subject.datetime).to eq(DateTime.new(2015,4,18,15,0))
    end
  end
end
