class Team

  TeamStruct = Struct.new(:team_id, :name, :country, :stadium)

  include XmlSoccerApi
  
  def self.all
    Rails.cache.fetch("teams", expires_in: 12.hours) do
      client.get_all_teams.collect{|team|
        TeamStruct.new(
          team[:team_id],
          team[:name],
          team[:country],
          team[:stadium]
        ) unless team[:stadium].blank?
      }.compact
    end
  end
  
  def self.find_by_stadium(stadium)
    all.find{|team| team.stadium == stadium }
  end

end
