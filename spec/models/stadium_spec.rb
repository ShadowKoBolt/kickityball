require 'rails_helper'

RSpec.describe Stadium, vcr: {cassette_name: "teams"} do

  describe ".all" do 

    subject { Stadium.all }

    it "is an array" do
      expect(subject.is_a?(Array)).to be true
    end

    it "contains 35 items" do
      expect(subject.count).to be(35)
    end

    it "contains only StadiumStructs" do
      subject.each do |element|
        expect(element).to be_a Stadium::StadiumStruct
      end
    end

  end

end
