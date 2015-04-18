require "rails_helper"

RSpec.describe "routing to fixtures index" do
  it "should be handled by the fixtures controllers index action" do
    expect(get: "teams/team-name/fixtures/home").to route_to(controller: "fixtures", action: "index", slug: "team-name")
  end
end
