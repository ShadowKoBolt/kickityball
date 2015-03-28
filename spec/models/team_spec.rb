require 'rails_helper'

RSpec.describe Team, vcr: {cassette_name: "teams"} do

  describe ".all" do 

    subject { Team.all }

    it "is an array" do
      expect(subject.is_a?(Array)).to be true
    end

    it "contains 35 items" do
      expect(subject.count).to be(35)
    end

    it "contains only TeamStructs" do
      subject.each do |element|
        expect(element).to be_a Team::TeamStruct
      end
    end

  end

  describe ".find_by_stadium" do

    context "existing stadium" do
      it "returns a TeamStruct" do
        expect(Team.find_by_stadium("Balmoor")).to be_a Team::TeamStruct
      end
    end

    context "invalid stadium" do
      it "return nil" do
        expect(Team.find_by_stadium("FooBar")).to be_nil
      end
    end

  end

end
