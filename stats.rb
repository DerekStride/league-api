require_relative 'league'
require 'pp'

def api_key
  api_file_path = File.join(Dir.home, '.riot', 'credentials')
  File.read(api_file_path).chomp
end

# pp api_key
#
# league_api = League.new(api_key)
#
# summoner = league_api.summoner_byname("SilentSith")
#
# sum = summoner[:silentsith][:id]
#
# matches = league_api.match_list(summoner[:silentsith][:id])
#
# pp matches
