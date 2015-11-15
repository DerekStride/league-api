require 'net/http'
require 'json'

# League interfaces with the riot API
class League
  attr_accessor :symbolize_json

  def initialize(api_key, region = 'na')
    @api = api_key
    @region = region
    @baseurl = "https://#{@region}.api.pvp.net"
    @static_data_url = "#{@baseurl}/api/lol/static-data/#{@region}/v1.2"
    @summoner_data_url = "#{@baseurl}/api/lol/#{@region}/v1.4/summoner"
    @matchs_url = "#{@baseurl}/api/lol/#{@region}/v2.2/matchlist/by-summoner"
    @symbolize_json = true
  end

  ########################################################################
  # Static
  ########################################################################
  def match(matchID, params = {})
    path_val = URI.encode_www_form_component(matchID)
    uri = URI("#{@baseurl}/api/lol/na/v2.2/match/#{path_val}")
    query(uri, params)
  end

  def champions(params = {})
    uri = URI("#{@static_data_url}/champion")
    query(uri, params)
  end

  def champion(champID,  params = {})
    path_val = URI.encode_www_form_component(champID)
    uri = URI("#{@static_data_url}/champion/#{path_val}")
    query(uri, params)
  end

  def items(params = {})
    uri = URI("#{@static_data_url}/item")
    query(uri, params)
  end

  def item(itemID, params = {})
    path_val = URI.encode_www_form_component(itemID)
    uri = URI("#{@static_data_url}/item/#{path_val}")
    query(uri, params)
  end

  def masteries(params = {})
    uri = URI("#{@static_data_url}/mastery")
    query(uri, params)
  end

  def mastery(masteryID, params = {})
    path_val = URI.encode_www_form_component(masteryID)
    uri = URI("#{@static_data_url}/mastery/#{path_val}")
    query(uri, params)
  end

  def runes(params = {})
    uri = URI("#{@static_data_url}/rune")
    query(uri, params)
  end

  def rune(runeID, params = {})
    path_val = URI.encode_www_form_component(runeID)
    uri = URI("#{@static_data_url}/rune/#{path_val}")
    query(uri, params)
  end

  def summoner_spells(params = {})
    uri = URI("#{@static_data_url}/summoner-spell")
    query(uri, params)
  end

  def summoner_spell(summoner_spellID, params = {})
    path_val = URI.encode_www_form_component(summoner_spellID)
    uri = URI("#{@static_data_url}/summoner-spell/#{path_val}")
    query(uri, params)
  end

  def languages
    uri = URI("#{@static_data_url}/languages")
    query(uri)
  end

  def map(params = {})
    uri = URI("#{@static_data_url}/map")
    query(uri, params)
  end

  def realm
    uri = URI("#{@static_data_url}/realm")
    query(uri)
  end

  def versions
    uri = URI("#{@static_data_url}/versions")
    query(uri)
  end

  ########################################################################
  # Summoner
  ########################################################################
  def summoner_byname(name)
    path_val = URI.encode_www_form_component(name)
    uri = URI("#{@summoner_data_url}/by-name/#{path_val}")
    query(uri)
  end

  def summoner_by_id(id)
    path_val = URI.encode_www_form_component(id)
    uri = URI("#{@summoner_data_url}/#{path_val}")
    query(uri)
  end

  def summoner_masteries(id)
    uri = URI("#{@summoner_data_url}/#{id}/masteries")
    query(uri)
  end

  def summoner_runes(id)
    path_val = URI.encode_www_form_component(id)
    uri = URI("#{@summoner_data_url}/#{path_val}/runes")
    query(uri)
  end

  def summoner_name(id)
    path_val = URI.encode_www_form_component(id)
    uri = URI("#{@summoner_data_url}/#{path_val}/name")
    query(uri)
  end

  ########################################################################
  # Matchlist
  ########################################################################
  def match_list(summonerID, params = {})
    uri = URI("#{@matchs_url}/#{summonerID}")
    query(uri, params)
  end

  private

  def query(uri, params = {})
    uri.query = URI.encode_www_form(params.merge(api_key: @api))
    response = Net::HTTP.get_response(uri)
    parse_response(response, symbolize_names: @symbolize_json)
  end

  def parse_response(response, params = {})
    bad_response(response)
    result = JSON.parse(response.body, params)
    # bad_request(result)
    result
  end

  def bad_response(response)
    puts 'ERROR:' \
    "\nCode: #{response.code}" \
    "\nBody: #{response.body}" unless response.is_a?(Net::HTTPSuccess)
  end
end

# l = League.new(api)
#
# pp l.champion(37, champData: 'stats')
#
# 51100547
#
# l.match(1_974_966_985)
# l.champions(champData: 'stats')
# l.champion(37, champData: 'stats')
# l.items(itemListData: 'stats')
# l.item(3725, itemListData: 'stats')
# l.masteries(masteryData: 'all')
# l.mastery(4331, masteryData: 'all')
# l.runes(runeData: 'stats')
# l.rune(5235, runeData: 'stats')
# l.summoner_spells
# l.summoner_spell(12)
# l.languages
# l.map
# l.realm
# l.versions
