module Lita
  module Handlers
    class DestinyHandler < Handler
      # Required configuration attribute
      config :api_key, type: String, required: true do
        # Do validation against provided api_key, MUST be 32 chars.
        validate do |value|
          # Raise error unless api_key is 32 chars.
           "must be 32 characters" unless value.respond_to?(:size) && value.size == 32
        end
      end

      # Bring in Destiny module
      include Destiny

      # Nightfall Route
      route(/^!(nightfall)/i, :nightfall , help: { "!nightfall" => "Get this weeks nightfall description and skulls" })

      # Weekly Strike Route
      route(/^!(weekly)/i, :weekly , help: { "!weekly" => "Get this weeks nightfall description and skulls" })

      # Xur Route
      route(/^!(xur)/i, :xur , help: { "!xur" => "Get Xur's inventory when availible" })

      # PoE Routes
      route(/^!(poe32)/i, :poe_32, help: { "!32" => "Get this weeks level 32 Prison of Elders information." })

      route(/^!(poe34)/i, :poe_34, help: { "!34" => "Get this weeks level 34 Prison of Elders information." })

      route(/^!(poe35)/i, :poe_35, help: { "!35" => "Get this weeks level 35 Prison of Elders information." })

      # Nightfall Activity Method
      #
      # Calls #build_activity_message(activity)
      # where activity would be nightfall.
      #
      def nightfall(response)
        # Set up our client
        destiny_client = Destiny::Client.new(api_key)
        # Set attachment color
        color = "#d35400"
        # Set attachment thumb_url
        thumb_url = "http://i.imgur.com/J9oBqJK.png"
        # Build the activity message with nightfall info
        build_activity_message(destiny_client.nightfall, response, color, thumb_url)
      end

      # Weekly Strike Activity Method
      #
      # Calls #build_activity_message(activity)
      # where activity would be the weekly strike.
      #
      def weekly(response)
        # Set up our client
        destiny_client = Destiny::Client.new(api_key)
        # Set attachment color
        color = "#f39c12"
        # Set attachment thumb_url
        thumb_url = "http://i.imgur.com/HhXoUCX.png"
        # Build the activity message with weekly info
        build_activity_message(destiny_client.weekly_strike, response, color, thumb_url)
      end

      # Xur Items Method
      #
      # Calls #build_xur_message()
      # Returns Xur inventory when availible.
      #
      def xur(response)
        # Set attachment color
        color = "#9b59b6"
        build_xur_message(response, color)
      end

      def poe_32(response)
        build_poe_message(32, response)
      end

      def poe_34(response)
        build_poe_message(34, response)
      end

      def poe_35(response)
        build_poe_message(35, response)
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
      def build_activity_message(activity, response, color, thumb_url)
        skull_fields = []
        activity[:skulls].each do |skull|
          skull_hash = {
            title: skull,
            value: "",
            short: true
          }
          skull_fields << skull_hash
        end
        # Create our attachment structure
        attachment_options = {

            color: "#d35400",

            title: "#{activity[:activityName]}",

            text: "#{activity[:activityDescription]}",

            fields: skull_fields,

            thumb_url: thumb_url
        }

        text = "#{activity[:activityDescription]}"
        # Create Attachment
        attachment = Lita::Adapters::Slack::Attachment.new(text, attachment_options)
        robot.chat_service.send_attachments(response.room, attachment)
      end

      # Xur Response Method
      #
      # Builds response to bring Xur items into chat.
      #
      # TODO: Is slow due to each item having to be polled from Bungies server.
      def build_xur_message(response)
        # Set up our client
        destiny_client = Destiny::Client.new(api_key)
        # Set xur to our clients xur method
        xur = destiny_client.xur

        # Check vendorDetails to see if anything is availible.
        if xur.nil?
          # If nil, send to chat that he isn't there.
          response.reply "Xur isn't in the game world right now."
        else
          # If not nil, cycle over items and build our items array.
          items = []
          xur.each do |key, value|
            value.each do |key, value|
              item_name = destiny_client.get_manifest_item(6, key[:item_hash])['itemName']
              item_cost = key[:item_cost]
              item_cost_name = destiny_client.get_manifest_item(6, key[:item_cost_hash])['itemName']
              constructed_item = "#{item_name}, #{item_cost} #{item_cost_name}"
              items << constructed_item
            end
          end
           # Once parsed, send completed message to chat.
          response.reply "*Xur is selling:*\n#{items.join("\n")}"
        end
      end

      def build_poe_message(level, response)
        # Set up our client
        destiny_client = Destiny::Client.new(api_key)
        # Returns:
        # {"activityHash"=>3508129769, "iconPath"=>"/img/destiny_content/arena/32_challenge.v2.png",
        # "rounds"=>[{"enemyRaceHash"=>711470098, "skulls"=>[4]}, {"enemyRaceHash"=>3265589059, "skulls"=>[2]},
        # {"enemyRaceHash"=>711470098, "skulls"=>[11]}, {"enemyRaceHash"=>3265589059, "skulls"=>[12]},
        # {"enemyRaceHash"=>3265589059, "skulls"=>[3]}],
        # "bossFight"=>false, "bossSkulls"=>[], "activeRewardIndexes"=>[0], "isCompleted"=>false}
        arena = destiny_client.arena(level)
        arena_hash = arena['activityHash']
        arena_rounds = arena['rounds']
        arena_name = destiny_client.activity_search(arena_hash)[:activityName]
        arena_description = destiny_client.activity_search(arena_hash)[:activityDescription]

        # For 32 & 34. Only goes to Round 5
        parsed_rounds = []
        arena_rounds.each_with_index do |round, index|
          enemy = destiny_client.enemy_race(round['enemyRaceHash']).capitalize
          raw_skulls = round['skulls']
          skulls = []
            raw_skulls.each do |skull|
              parsed_skulls = destiny_client.skulls(skull).capitalize
              skulls << parsed_skulls
            end
          parsed_round = "Round #{index+1}: #{enemy}-- #{skulls.join(", ")}"
          parsed_rounds << parsed_round
        end

        # For 35, final skolas round.
        if arena['bossFight'] == true
          skulls = []
          raw_skulls = arena['bossSkulls']
          raw_skulls.each do |skull|
            parsed_skulls = destiny_client.skulls(skull).capitalize
            skulls << parsed_skulls
          end
          parsed_round  = "Round 6: Skolas-- #{skulls.join(", ")}"
          parsed_rounds << parsed_round
        end

        response.reply "*Level #{level} Prison of Elders*\n#{arena_name}\n#{arena_description}\n#{parsed_rounds.join("\n")}"



      end
    end

    # Register the handler
    Lita.register_handler(DestinyHandler)
  end
end
