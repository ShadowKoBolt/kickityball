require 'rails_helper'

RSpec.describe TeamsController do

  describe "GET #index", :vcr do
    subject{ get :index }
    it "assigns teams" do
      subject
      expect(assigns(:teams)).to eq(Team.all)
    end

    it "returns http success" do
      expect(subject).to have_http_status(:success)
    end

    it "returns json" do
      expect(subject.content_type).to eq("application/json")
    end
  end

end
