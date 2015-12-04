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
    @stats_url = "#{@baseurl}/api/lol/#{@region}/v1.3/stats/by-summoner"
    @symbolize_json = true
  end

  ########################################################################
  # Static
  ########################################################################
  def match(match_id, params = {})
    path_val = URI.encode_www_form_component(match_id)
    uri = URI("#{@baseurl}/api/lol/na/v2.2/match/#{path_val}")
    query(uri, params)
  end

  def champions(params = {})
    uri = URI("#{@static_data_url}/champion")
    query(uri, params)
  end

  def champion(champ_id, params = {})
    path_val = URI.encode_www_form_component(champ_id)
    uri = URI("#{@static_data_url}/champion/#{path_val}")
    query(uri, params)
  end

  def items(params = {})
    uri = URI("#{@static_data_url}/item")
    query(uri, params)
  end

  def item(item_id, params = {})
    path_val = URI.encode_www_form_component(item_id)
    uri = URI("#{@static_data_url}/item/#{path_val}")
    query(uri, params)
  end

  def masteries(params = {})
    uri = URI("#{@static_data_url}/mastery")
    query(uri, params)
  end

  def mastery(mastery_id, params = {})
    path_val = URI.encode_www_form_component(mastery_id)
    uri = URI("#{@static_data_url}/mastery/#{path_val}")
    query(uri, params)
  end

  def runes(params = {})
    uri = URI("#{@static_data_url}/rune")
    query(uri, params)
  end

  def rune(rune_id, params = {})
    path_val = URI.encode_www_form_component(rune_id)
    uri = URI("#{@static_data_url}/rune/#{path_val}")
    query(uri, params)
  end

  def summoner_spells(params = {})
    uri = URI("#{@static_data_url}/summoner-spell")
    query(uri, params)
  end

  def summoner_spell(summoner_spell_id, params = {})
    path_val = URI.encode_www_form_component(summoner_spell_id)
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
  def matchlist(summoner_id, params = {})
    id = normalize_summoner_id(summoner_id)
    path_val = URI.encode_www_form_component(id)
    uri = URI("#{@matchs_url}/#{path_val}")
    query(uri, params)
  end

  ########################################################################
  # Stats
  ########################################################################
  def stats(summoner_id, params = {})
    id = normalize_summoner_id(summoner_id)
    path_val = URI.encode_www_form_component(id)
    uri = URI("#{@stats_url}/#{path_val}/ranked")
    query(uri, params)
  end

  private

  def query(uri, params = {})
    uri.query = URI.encode_www_form(params.merge(api_key: @api))
    response = nil
    5.times do |_|
      response = Net::HTTP.get_response(uri)
      break unless response.code == '429'
      sleep(response['retry-after'].to_i || 2)
    end
    parse_response(response, symbolize_names: @symbolize_json)
  end

  def parse_response(response, params = {})
    bad_response(response)
    result = JSON.parse(response.body, params)
    pp result unless response.is_a?(Net::HTTPSuccess)
    # bad_request(result)
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
    id = name.downcase
    summoner = summoner_byname(id)
    if @symbolize_json
      return summoner.fetch(id.to_sym).fetch(:id)
    else
      return summoner.fetch(id).fetch('id')
    end
  end
end
