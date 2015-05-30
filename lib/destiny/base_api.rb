require 'httparty'
require 'pp'
# DestinyAPI module wrapper
module DestinyAPI
  # Base API Class
  # 
  # Usage:
  # destiny = DestinyAPI::Base.new(api_token)
  # 
  class Base
    # Include HTTParty Module
    include HTTParty
    # Auto-parse responses from Bungie as JSON
    format :json
    # Set base uri
    base_uri 'www.bungie.net/Platform/Destiny/'


    # Init the Destiny API with Bungie API stored in ENV variable
    # 
    # Usage:
    #   destiny = DestinyAPI::Base.new('6971067dec36c6597cd57789a62f48f0')
    # 
    # Arguments:
    #   api_token: (String)
    # 
    def initialize(api_token)
      @headers = { 'X-API-Key' => api_token, 'Content-Type' => 'application/json' }
    end

    # GET the days advisor report from http://www.bungie.net/platform/destiny/advisors/
    # 
    # Usage:
    #   destiny.advisors
    # 
    def advisors
      raw_data = self.class.get('/Advisors', headers: @headers)
      parsed = raw_data.parsed_response['Response']['data']
    end

    # GET the activity information from http://www.bungie.net/platform/destiny/manifest/activity/{activity_hash}/
    # 
    # Raw argument will return an unmodified respons from Bungie.
    # 
    # Usage:
    #   destiny.activity('3508129769', false)
    #   
    # Arguments: 
    #   activity_hash: (String)
    #   raw: (Boolean)
    #   
    def activity(activity_hash, raw=false)
      raw_data = self.class.get("/Manifest/Activity/#{activity_hash}").parsed_response['Response']['data']['activity']
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

    # GET the weekly nightfall info from http://www.bungie.net/platform/destiny/manifest/activity/#{activity_hash}
    # 
    # Optional boolean argument.
    # 
    # Usage:
    #  destiny.nightfall(true)
    #  
    # Arguments:
    #  raw: (boolean)
    # 
    def nightfall(raw=false)
      nightfall_activity_hash = self.advisors['nightfallActivityHash']
      activity(nightfall_activity_hash, raw)
    end

    # GET the weekly nightfall info from http://www.bungie.net/platform/destiny/manifest/activity/#{activity_hash}
    # Returns an array of three items, only need one for the skulls and location.
    # 
    # Optional boolean argument, defaults to false from activity method to return basic information for Lita bot.
    # 
    # Usage:
    #  destiny.weekly_strike(false)
    #  
    # Arguments:
    #  raw: (boolean)
    # 
    def weekly_strike(raw=false)
      heroic_strike_hashes = self.advisors['heroicStrikeHashes']
      activity(heroic_strike_hashes[0], raw)
    end

    # GET the weekly nightfall info from http://www.bungie.net/platform/destiny/manifest/activity/#{activity_hash}
    # 
    # No known endpoints.
    def arena(options={})
    end
    
    def search_destiny_player(player_name, platform_type)
      raw_data = self.class.get("/SearchDestinyPlayer/#{platform_type}/#{player_name}/").parsed_response['Response']['membershipId']
    end
  
    def get_destiny_account(player_name, platform_type)
      member_id = self.search_destiny_player(player_name, platform_type)
      raw_data = self.class.get("/#{platform_type}/Account/#{member_id}/").parsed_response['Response']['data']
    end
    
    def get_manifest_item(type_id, item_id)
      raw_data = self.class.get("/Manifest/#{type_id}/#{item_id}").parsed_response['Response']['data']['inventoryItem']
    end

    # WIP: Pull xur inventory
    # http://www.bungie.net/platform/destiny/advisors/xur/
    def xur(raw=false)
      raw_data = self.class.get('/Advisors/Xur/').parsed_response['Response']['data']
      vendor_hash = raw_data['vendorHash']
      sale_items = {}
      
      # Hacky? Probs.
      raw_data['saleItemCategories'].each do |category|
        items = { category['categoryTitle'] => category['saleItems'].map!{|item| {:item_hash => item['item']['itemHash'], :item_cost => item['costs'][0]['value'], :item_cost_hash => item['costs'][0]['itemHash']} } }
        sale_items.merge!(items)
      end
      
      if raw
        raw_data
      else
        sale_items
      end
    end
    
    def vendor(vendor_hash)
      raw_data = self.class.get("/Manifest/Vendor/#{vendor_hash}").parsed_response['Response']['data']['vendor']['summary']
    end

    # Pull the days bounties
    def bounties
    end
    
    # GET information about a place, specifically a planet.
    # 
    # Usage:
    #  destiny.place('3747705955')
    #  
    # Arguments:
    #  place_hash: (String)
    #  
    def place(place_hash)
      raw data = self.class.get('/Manifest/Place/#{place_hash}').parsed_response['Response']['data']['place']
      response = { place_name: raw_data['placeName'], place_desc: raw_data['placeDescription'] }
    end

    # GET information about a destination, specifically a location on a planet.
    # 
    # Usage:
    #  destiny.destination('518553403')
    #  
    # Arguments:
    #  destination_hash: (String)
    #  
    def destination(destination_hash)
      raw_data = self.class.get('/Manifest/Destination/#{destination_hash}').parsed_response['Response']['data']
      response = { dest_name: raw_data['destinationName'], dest_desc: raw_data['destinationDescription'] }
    end
  end
end
