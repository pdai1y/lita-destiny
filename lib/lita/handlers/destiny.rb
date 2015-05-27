module Lita
  module Handlers
    class Destiny < Handler
      include DestinyApi
      config :api_key
      
      DESTINY = DestinyApi.new(config.api_key)
      
      route(/!+?\b(nightfall)/i, :build_activity_message(DESTINY.nightfall), help: { "!nightfall" => "Get this weeks nightfall description and skulls" })
      
            
      
      # activity = { activityName: raw_data['activityName'], activityDescription: raw_data['activityDescription'], skulls: skulls }
      def build_activity_message(activity)
        activity = activity
        #response.reply("#{activity["activityName"]}\n #{activityDescription["activityDescription"]}\n #{skulls["skulls"]}")
        response.reply("Hi!")
      end
     
    end

    Lita.register_handler(Destiny)
  end
end