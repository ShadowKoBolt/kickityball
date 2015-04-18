class Team < Struct.new(:slug, :name)

  def self.all
    Rails.cache.fetch("teams", expires_in: 12.hours) do
      League.all.collect do |league|
        response = Excon.get("http://www.bbc.co.uk/sport/football/#{league.slug}/table")
        html = Nokogiri::HTML(response.body)
        team_rows = html.css("table.table-stats tbody tr").collect do |team_row|
          slug = team_row.attr("data-team-slug")
          name_link = team_row.at_css("td.team-name a")
          if name_link
            name = name_link.text
            self.new(slug, name)
          end
        end
      end.flatten.compact.uniq(&:name).sort_by(&:name)
    end
  end

  def self.find_by_slug(slug)
    self.all.find{|t| t.slug == slug }
  end

  def fixtures
    Rails.cache.fetch("teams/#{slug}/fixtures", expires_in: 12.hours) do
      response = Excon.get("http://www.bbc.co.uk/sport/football/teams/#{slug}/fixtures")    
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

  def home_fixtures
    fixtures.select{|f| f.home_team == name }
  end

  class Fixture < Struct.new(:year, :date, :time, :home_team, :away_team)
    def name
      [home_team, away_team].join(" V ")
    end

    def datetime_string
      [time, date, year].join(" ")
    end

    def datetime
      DateTime.strptime(datetime_string, "%H:%M %a %e %b %Y")
    end
  end

end
