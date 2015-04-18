require "rails_helper"

RSpec.describe "routing to teams index" do
  it "should be handled by the teams controllers index action" do
    expect(get: "teams").to route_to(controller: "teams", action: "index")
  end
end
