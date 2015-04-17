class League < Struct.new(:slug, :name)

  def self.all
    response = Excon.get("http://www.bbc.co.uk/sport/football/leagues-competitions")
    html = Nokogiri::HTML(response.body)
    html.at_css("div.region-list").css("ul li a").collect do |league_link|
      matches = league_link.attr("href").match(/\/football\/([^\/]*)/)
      if matches
        slug = matches.captures.first
        name = league_link.text
        self.new(slug, name)
      end
    end.flatten.compact
  end

end
