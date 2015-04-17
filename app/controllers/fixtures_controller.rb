class FixturesController < ApplicationController

  def index
    team = Team.find_by_slug(params[:slug])
    @fixtures = team.home_fixtures
  end

end
