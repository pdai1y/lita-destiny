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

      # Nightfall Route
      route(/^!(nightfall)/i, :nightfall , help: { "!nightfall" => "Get this weeks nightfall description and skulls" })
      
      # Weekly Strike Route
      route(/^!(weekly)/i, :weekly , help: { "!weekly" => "Get this weeks nightfall description and skulls" })
      
      # Xur Route
      route(/^!(xur)/i, :xur , help: { "!xur" => "Get Xur's inventory when availible" })
      
      # Nightfall Activity Method
      # 
      # Calls #build_activity_message(activity)
      # where activity would be nightfall.
      #     
      def nightfall(response)
        # Set up our client
        destiny_client = DestinyAPI::Base.new(api_key)
        # Build the activity message with nightfall info
        build_activity_message(destiny_client.nightfall, response)
      end
      
      # Weekly Strike Activity Method
      # 
      # Calls #build_activity_message(activity)
      # where activity would be the weekly strike.
      #      
      def weekly(response)
        # Set up our client
        destiny_client = DestinyAPI::Base.new(api_key)
        # Build the activity message with weekly info
        build_activity_message(destiny_client.weekly_strike, response)
      end
      
      # Xur Items Method
      # 
      # Calls #build_xur_message()
      # Returns Xur inventory when availible.  
      # 
      def xur(response)
        build_xur_message(response)
      end
      
      # Begin private methods
      # 
      private
      
      # Set our api_key for calling in route methods.
      # 
      def api_key
        config.api_key
      end
      
      # Generalized Response Method
      # 
      # Used by activity methods to bring concise activity info
      # into the chat.
      # 
      def build_activity_message(activity, response)
        # Set activity
        activity_hash = activity
        # Send response
        response.reply("#{activity_hash[:activityName]}\n#{activity_hash[:activityDescription]}\nSkulls: #{activity_hash[:skulls].join(', ')}")
      end

      # Xur Response Method
      # 
      # Builds response to bring Xur items into chat.
      # 
      def build_xur_message(response)
        # Set up our client
        destiny_client = DestinyAPI::Base.new(api_key)
        # Set xur to our clients xur method
        xur = destiny_client.xur
        # Check vendorDetails to see if anything is availible.
        if xur[:vendorDetails].nil?
          # If nothing, send to chat that he isn't there.
          response.reply "Xur isn't in the tower right now."
        else
          # If something, send to chat what he is selling.
          response.reply "Xur is selling: "
        end
      end
    end
    
    # Register the handler
    Lita.register_handler(Destiny)
  end
end