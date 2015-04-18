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
    self.all.find{|t| t.slug == slug } || raise(InvalidSlugException, "Cannot find team with this slug")
  end

  def home_fixtures
    Fixture.find_all_by_team_slug(slug).select{|f| f.home_team == name }
  end

  class InvalidSlugException < Exception
  end

end
