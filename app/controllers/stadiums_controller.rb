class StadiumsController < ApplicationController
  def index
    render json: Stadium.all.to_json
  end
end
