require 'httparty'

module DestinyAPI
  class Base
    include HTTParty
    format :json
    base_uri 'www.bungie.net/platform/destiny/'


    # Init the Destiny API with Bungie API stored in ENV variable
    # destiny = Destiny.new(api_token)
    def initialize(api_token)
      @headers = { 'X-API-Key' => api_token, 'Content-Type' => 'application/json' }
    end

    # Pull the days advisor report from http://www.bungie.net/platform/destiny/advisors/
    # destiny.advisors
    def advisors
      raw_data = self.class.get('/advisors', headers: @headers)
      parsed = raw_data.parsed_response['Response']['data']
    end

    def activity(activity_hash, raw=false)
      raw_data = self.class.get("/manifest/activity/#{activity_hash}").parsed_response['Response']['data']['activity']
      skulls = []
      raw_data['skulls'].each do |skull|
        skulls << skull['displayName']
      end
      unless raw == true
        parsed_data = { activityName: raw_data['activityName'], activityDescription: raw_data['activityDescription'], skulls: skulls }
      else
        raw_data
      end
    end

    # Pull the weekly nightfall info from http://www.bungie.net/platform/destiny/manifest/activity/#{activity_hash}
    # Optional boolean argument, defaults to false from activity method to only return basic information for Lita bot.
    # 
    # destiny.nightfall
    # 
    def nightfall(options={})
      nightfall_activity_hash = self.advisors['nightfallActivityHash']
      activity(nightfall_activity_hash, boolean)
    end

    # Pull the weekly nightfall info from http://www.bungie.net/platform/destiny/manifest/activity/#{activity_hash}
    # Returns an array of three items, only need one for the skulls and location.
    # 
    # Optional boolean argument, defaults to false from activity method to return basic information for Lita bot.
    # 
    # destiny.weekly_strike(false)
    # 
    def weekly_strike(options={})
      heroic_strike_hashes = self.advisors['heroicStrikeHashes']
      activity(heroic_strike_hashes[0], boolean)
    end

    # Pull the weekly nightfall info from http://www.bungie.net/platform/destiny/manifest/activity/#{activity_hash}
    #
    # 
    # No known endpoints.
    def arena(options={})
    end

    # WIP: Pull xur inventory
    # http://www.bungie.net/platform/destiny/advisors/xur/?definitions=true
    def xur
      raw_data = self.class.get('/advisors/xur/?definitions=true').parsed_response['Response']['definitions']
    end

    # Pull the days bounties
    def bounties
    end

    def place(place_hash)
      raw data = self.class.get('/manifest/place/#{place_hash}').parsed_response['Response']['data']['place']
      response = { place_name: raw_data['placeName'], place_desc: raw_data['placeDescription'] }
    end

    def destination(destination_hash)
      raw_data = self.class.get('/manifest/destination/#{destination_hash}').parsed_response['Response']['data']
      response = { dest_name: raw_data['destinationName'], dest_desc: raw_data['destinationDescription'] }
    end
  end
end
