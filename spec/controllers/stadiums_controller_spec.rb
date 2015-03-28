require 'rails_helper'

RSpec.describe StadiumsController, type: :controller, vcr: {cassette_name: "teams"}  do

  describe "GET #index" do

    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    context "JSON" do

      before(:each) { get :index }

      subject{ JSON.parse(response.body) }

      it "is an array" do
        expect(subject).to be_a Array
      end

      it "contains elements with a name" do
        expect(subject.first).to have_key "name"
      end

    end

  end

end
