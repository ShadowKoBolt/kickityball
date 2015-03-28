module XmlSoccerApi

  extend ActiveSupport::Concern

  class_methods do
    def client 
      @client ||= Xmlsoccer::Client.new(api_key: ENV["SOCCERXML_API_KEY"], api_type: ENV["SOCCERXML_API_TYPE"])
    end
  end

end
