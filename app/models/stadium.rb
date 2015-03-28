class Stadium

  StadiumStruct = Struct.new(:name)

  def self.all
    Rails.cache.fetch("stadiums", expires_in: 12.hours) do
      Team.all.collect{|team|
        StadiumStruct.new(team.stadium) if team.stadium.present?
      }.compact
    end
  end

end
