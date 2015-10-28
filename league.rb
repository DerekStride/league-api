require 'net/http'
require 'json'

# League interfaces with the riot API
class League
  attr_accessor :baseurl

  def initialize(api_key, region = 'na')
    @api = api_key
    @region = region
    @baseurl = baseurl || "https://#{@region}.api.pvp.net"
    @static_data_url = "#{@baseurl}/api/lol/static-data/#{@region}/v1.2"
    @summoner_data_url = "#{@baseurl}/api/lol/#{@region}/v1.4/summoner"
  end

  def match(matchID, params = {})
    uri = URI("#{@baseurl}/api/lol/na/v2.2/match/#{matchID}")
    query(uri, params)
  end

  def champions(params = {})
    uri = URI("#{@static_data_url}/champion")
    query(uri, params)
  end

  def champion(champID,  params = {})
    uri = URI("#{@static_data_url}/champion/#{champID}")
    query(uri, params)
  end

  def items(params = {})
    uri = URI("#{@static_data_url}/item")
    query(uri, params)
  end

  def item(itemID, params = {})
    uri = URI("#{@static_data_url}/item/#{itemID}")
    query(uri, params)
  end

  def masteries(params = {})
    uri = URI("#{@static_data_url}/mastery")
    query(uri, params)
  end

  def mastery(masteryID, params = {})
    uri = URI("#{@static_data_url}/mastery/#{masteryID}")
    query(uri, params)
  end

  def runes(params = {})
    uri = URI("#{@static_data_url}/rune")
    query(uri, params)
  end

  def rune(runeID, params = {})
    uri = URI("#{@static_data_url}/rune/#{runeID}")
    query(uri, params)
  end

  def summoner_spells(params = {})
    uri = URI("#{@static_data_url}/summoner-spell")
    query(uri, params)
  end

  def summoner_spell(summoner_spellID, params = {})
    uri = URI("#{@static_data_url}/summoner-spell/#{summoner_spellID}")
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

  #summoner section of the api
  def summoner_byname(name)
    uri = URI("#{@summoner_data_url}/by-name/#{name}")
    query(uri)
  end

  #matchlist
  def match_list(summoner_ID)
    uri = URI("#{@baseurl}/api/lol/#{@region}/v2.2/matchlist/by-summoner/#{summoner_ID}")
    query(uri)
  end

  private

  def query(uri, params = {})
    uri.query = URI.encode_www_form(params.merge(api_key: @api))
    response = Net::HTTP.get_response(uri)
    parse_response(response, symbolize_names: true)
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
# # 51100547
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
