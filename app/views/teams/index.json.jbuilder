json.teams @teams do |team|
  json.name team.name
  json.home_fixtures_url team_home_fixtures_url(slug: team.slug)
end
