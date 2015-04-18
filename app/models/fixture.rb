class Fixture < Struct.new(:year, :date, :time, :home_team, :away_team)
  def name
    [home_team, away_team].join(" V ")
  end

  def datetime
    DateTime.strptime(datetime_string, "%H:%M %a %e %b %Y")
  end

  def self.find_all_by_team_slug(team_slug)
    team = Team.find_by_slug(team_slug)
    Rails.cache.fetch("teams/#{team.slug}/fixtures", expires_in: 12.hours) do
      response = Excon.get("http://www.bbc.co.uk/sport/football/teams/#{team.slug}/fixtures")    
      html = Nokogiri::HTML(response.body)
      html.css("div.fixtures-table table.table-stats").collect do |month_table|
        year = month_table.at_css("caption").text.gsub(/\D/, "")
        month_table.css("tbody tr").collect do |fixture_row|
          year = year
          date = fixture_row.css("td.match-date").text.strip
          time = fixture_row.css("td.kickoff").text.strip
          teams = fixture_row.css("td.match-details").text.split(" V ")
          home_team = teams.first.strip
          away_team = teams.last.strip
          Fixture.new(year, date, time, home_team, away_team)
        end
      end.flatten.compact
    end
  end

  private
    def datetime_string
      [time, date, year].join(" ")
    end

end

