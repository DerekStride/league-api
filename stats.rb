require_relative 'league'
require 'pp'

def api_key
  api_file_path = File.join(Dir.home, '.riot', 'credentials')
  File.read(api_file_path).chomp
end

def match_list_from_summoner_name(name, api)
  summoner = api.summoner_byname(name)
  api.match_list(summoner.fetch(name.to_sym).fetch(:id))
end

def champions_played(match_list, api)
  played_champs = Hash.new(0)
  champs = champ_keys(api)
  matches = match_list.fetch(:matches)
  matches.each do |match|
    played_champs[champs.fetch(match.fetch(:champion).to_s.to_sym).to_sym] += 1
  end
  pp played_champs
end

def champ_keys(api)
  api.champions(champData: 'keys').fetch(:keys)
end

league_api = League.new(api_key)
puts 'Enter Summoner Name'
name = gets.chomp.sub(' ', '').downcase
list = match_list_from_summoner_name(name, league_api)
champions_played(list, league_api)
