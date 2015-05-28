module Lita
  module Handlers
    class Destiny < Handler    
      # Required configuration attribute
      config :api_key, type: String, required: true do 
        validate do |value|
           "must be 32 characters" unless value.respond_to?(:size) && value.size == 32
        end
      end
      
      # Bring in DestinyAPI module
      include DestinyAPI
            
      # Set up our client
      #destiny_client = DestinyAPI::Base.new(config.api_key).call

      
      route(/^!\w(.*)/i, :nightfall , help: { "!nightfall" => "Get this weeks nightfall description and skulls" })
      
            
      def nightfall(response)
        build_activity_message(destiny_client.nightfall, response)
      end
      
      # activity = { activityName: raw_data['activityName'], activityDescription: raw_data['activityDescription'], skulls: skulls }
      def build_activity_message(activity, response)
        activity = activity
        response.reply("#{activity["activityName"]}\n #{activityDescription["activityDescription"]}\n #{skulls["skulls"]}")
      end
     
    end

    Lita.register_handler(Destiny)
  end
end