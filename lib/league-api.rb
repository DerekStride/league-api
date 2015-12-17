require_relative 'league-api/core'
require_relative 'league-api/methods'

module API
  # LeagueAPI interfaces with the riot API
  #
  # Author::    Derek Stride  (mailto:djgstride@gmail.com)
  # License::   MIT
  class LeagueAPI
    include API::League::Core
    include API::League::Methods

    def initialize(api_key, region = 'na')
      @api = api_key
      @region = region
      @baseurl = "https://#{@region}.api.pvp.net"
      @static_data_url = "#{@baseurl}/api/lol/static-data/#{@region}/v1.2"
      @summoner_data_url = "#{@baseurl}/api/lol/#{@region}/v1.4/summoner"
      @matchs_url = "#{@baseurl}/api/lol/#{@region}/v2.2/matchlist/by-summoner"
      @stats_url = "#{@baseurl}/api/lol/#{@region}/v1.3/stats/by-summoner"
      @cache_directory = 'league'
      @symbolize_json = true
      @retries = 5
    end
  end
end
