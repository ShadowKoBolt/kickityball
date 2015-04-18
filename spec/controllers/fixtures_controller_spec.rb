require 'rails_helper'

RSpec.describe FixturesController do

  describe "GET #index", :vcr do
    subject{ get :index, slug: "aberdeen" }
    it "assigns fixtures" do
      subject
      team = Team.find_by_slug("aberdeen")
      expect(assigns(:fixtures)).to eq(team.home_fixtures)
    end

    it "returns http success" do
      expect(subject).to have_http_status(:success)
    end

    it "returns json" do
      expect(subject.content_type).to eq("application/json")
    end
  end

end
