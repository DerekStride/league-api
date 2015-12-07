require 'net/http'
require 'json'
require 'jsoncache'

# LeagueAPICore contains the core functionality for the riot API
module LeagueAPICore
  include JSONCache

  attr_accessor :symbolize_json, :retries

  private

  def get_response(uri, delta, params = {})
    json_params = { symbolize_names: @symbolize_json }
    url = uri.to_s
    return retrieve_cache(url, json_params) if cached?(url, delta)

    uri.query = URI.encode_www_form(params.merge(api_key: @api))
    query(uri)
  end

  def query(uri)
    @retries.times do |_|
      response = Net::HTTP.get_response(uri)
      if %w(429 500 503).include?(response.code)
        sleep(response['retry-after'].to_i || 2)
      else
        return parse_response(response, uri.to_s)
      end
    end
  end

  # Overwrite the JSONCache method to support cached data
  def uri_to_file_path_root(uri)
    uri.gsub(%r{[\.\/]|https:\/\/.*v\d\.\d|\?api_key=.*}, '')
  end

  def parse_response(response, uri)
    bad_response(response)
    result = JSON.parse(response.body, symbolize_names: @symbolize_json)
    cache_file(result, uri) if response.is_a?(Net::HTTPSuccess)
    result
  end

  def bad_response(response)
    puts 'ERROR:' \
    "\nCode: #{response.code}" \
    "\nBody: #{response.body}" unless response.is_a?(Net::HTTPSuccess)
  end

  def normalize_summoner_id(id)
    return id if id.is_a? Fixnum
    summoner_id_from_name(id)
  end

  def summoner_id_from_name(name)
    id = name.chomp.delete(' ').downcase
    summoner = summoner_byname(id)
    if @symbolize_json
      return summoner.fetch(id.to_sym).fetch(:id)
    else
      return summoner.fetch(id).fetch('id')
    end
  end
end

# LeagueAPIStaticMethods provides methods to get Static API Data
module LeagueAPISummonerMethods
  def summoner_byname(name)
    path_val = URI.encode_www_form_component(name)
    uri = URI("#{@summoner_data_url}/by-name/#{path_val}")
    get_response(uri, 0)
  end

  def summoner_by_id(id)
    path_val = URI.encode_www_form_component(id)
    uri = URI("#{@summoner_data_url}/#{path_val}")
    get_response(uri, 0)
  end

  def summoner_masteries(id)
    uri = URI("#{@summoner_data_url}/#{id}/masteries")
    get_response(uri, 0)
  end

  def summoner_runes(id)
    path_val = URI.encode_www_form_component(id)
    uri = URI("#{@summoner_data_url}/#{path_val}/runes")
    get_response(uri, 0)
  end

  def summoner_name(id)
    path_val = URI.encode_www_form_component(id)
    uri = URI("#{@summoner_data_url}/#{path_val}/name")
    get_response(uri, 0)
  end
end

# LeagueAPIStaticMethods provides methods to get Static API Data
module LeagueAPIStaticMethods
  def match(match_id, params = {})
    path_val = URI.encode_www_form_component(match_id)
    uri = URI("#{@baseurl}/api/lol/na/v2.2/match/#{path_val}")
    get_response(uri, 0, params)
  end

  def champions(params = {})
    uri = URI("#{@static_data_url}/champion")
    get_response(uri, 300, params)
  end

  def champion(champ_id, params = {})
    path_val = URI.encode_www_form_component(champ_id)
    uri = URI("#{@static_data_url}/champion/#{path_val}")
    get_response(uri, 0, params)
  end

  def items(params = {})
    uri = URI("#{@static_data_url}/item")
    get_response(uri, 300, params)
  end

  def item(item_id, params = {})
    path_val = URI.encode_www_form_component(item_id)
    uri = URI("#{@static_data_url}/item/#{path_val}")
    get_response(uri, 0, params)
  end

  def masteries(params = {})
    uri = URI("#{@static_data_url}/mastery")
    get_response(uri, 300, params)
  end

  def mastery(mastery_id, params = {})
    path_val = URI.encode_www_form_component(mastery_id)
    uri = URI("#{@static_data_url}/mastery/#{path_val}")
    get_response(uri, 0, params)
  end

  def runes(params = {})
    uri = URI("#{@static_data_url}/rune")
    get_response(uri, 300, params)
  end

  def rune(rune_id, params = {})
    path_val = URI.encode_www_form_component(rune_id)
    uri = URI("#{@static_data_url}/rune/#{path_val}")
    get_response(uri, 0, params)
  end

  def summoner_spells(params = {})
    uri = URI("#{@static_data_url}/summoner-spell")
    get_response(uri, 300, params)
  end

  def summoner_spell(summoner_spell_id, params = {})
    path_val = URI.encode_www_form_component(summoner_spell_id)
    uri = URI("#{@static_data_url}/summoner-spell/#{path_val}")
    get_response(uri, 0, params)
  end

  def languages
    uri = URI("#{@static_data_url}/languages")
    get_response(uri, 0)
  end

  def map(params = {})
    uri = URI("#{@static_data_url}/map")
    get_response(uri, false, 0, params)
  end

  def realm
    uri = URI("#{@static_data_url}/realm")
    get_response(uri, false, 0)
  end

  def versions
    uri = URI("#{@static_data_url}/versions")
    get_response(uri, false, 0)
  end
end

# LeagueAPIMethods provides methods to talk to the Riot API, requires
# implementing a get_response method to do the API calls
module LeagueAPIMethods
  include LeagueAPIStaticMethods
  include LeagueAPISummonerMethods

  ########################################################################
  # Matchlist
  ########################################################################
  def matchlist(summoner_id, params = {})
    id = normalize_summoner_id(summoner_id)
    path_val = URI.encode_www_form_component(id)
    uri = URI("#{@matchs_url}/#{path_val}")
    get_response(uri, 300, params)
  end

  ########################################################################
  # Stats
  ########################################################################
  def stats(summoner_id, params = {})
    id = normalize_summoner_id(summoner_id)
    path_val = URI.encode_www_form_component(id)
    uri = URI("#{@stats_url}/#{path_val}/ranked")
    get_response(uri, 300, params)
  end
end

# League interfaces with the riot API
class League
  include LeagueAPICore
  include LeagueAPIMethods

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
