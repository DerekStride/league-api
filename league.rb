require 'net/http'
require 'json'
require 'pp'

# League interfaces with the riot API
class League
  attr_accessor :baseurl

  def initialize(baseurl = nil, api_key)
    @api = api_key
    @baseurl = baseurl || 'https://na.api.pvp.net/'
  end

  def match(matchID, params = {})
    uri = URI("#{@baseurl}/api/lol/na/v2.2/match/#{matchID}")
    query(uri, params)
  end

  def champions(params = {})
    uri = URI("#{@baseurl}/api/lol/static-data/na/v1.2/champion")
    query(uri, params)
  end

  def champion(champID,  params = {})
    uri = URI("#{@baseurl}/api/lol/static-data/na/v1.2/champion/#{champID}")
    query(uri, params)
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

api_file_path = File.join(Dir.home, '.riot', 'credentials')
api = File.read(api_file_path).chomp

l = League.new(api)

pp l.champion(37, champData: 'stats')
