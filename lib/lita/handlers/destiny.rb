module Lita
  module Handlers
    class Destiny < Handler    
      # Required configuration attribute
      config :api_key, type: String, required: true do
        # Do validation against provided api_key, MUST be 32 chars.
        validate do |value|
          # Raise error unless api_key is 32 chars.
           "must be 32 characters" unless value.respond_to?(:size) && value.size == 32
        end
      end
      
      # Bring in DestinyAPI module
      include DestinyAPI
      
      # Getter method for Class.api_key
      def api_key
        config.api_key
      end
      
      # Set up our client
      destiny_client = DestinyAPI::Base.new(api_key)

      # Nightfall Route
      route(/^!\w(.*)/i, :nightfall , help: { "!nightfall" => "Get this weeks nightfall description and skulls" })
      
      # Nightfall Activity Method
      # 
      # Calls #build_activity_message(activity)
      # where activity would be nightfall.       
      def nightfall(response)
        build_activity_message(destiny_client.nightfall, response)
      end
      
      # Generalized Response Method
      # 
      # Used by activity methods to bring concise activity info
      # into the chat.
      def build_activity_message(activity, response)
        # Set activity
        activity = activity
        # Send response
        response.reply("#{activity["activityName"]}\n #{activityDescription["activityDescription"]}\n #{skulls["skulls"]}")
      end
     
    end
    
    # Register the handler
    Lita.register_handler(Destiny)
  end
end