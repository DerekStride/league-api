require_relative 'league'
require 'pp'

def api_key
  api_file_path = File.join(Dir.home, '.riot', 'credentials')
  File.read(api_file_path).chomp
end

def match_list_from_summoner_name(name, api)
  name.downcase!
  summoner = api.summoner_byname(name)
  api.match_list(summoner.fetch(name.to_sym).fetch(:id))
end

def champion_key_from_id(champs, id)
  champs.each {|champion|
    if champion.fetch(:id) == id
      return champion.fetch(:key)
    end
  }
end

def champions_played(match_list, champions)
  played_champions = Hash.new(0)
  # pp match_list
  matches = match_list.fetch(:matches)
  matches.each {|match|
    played_champions[champion_key_from_id(champions, match.fetch(:champion)).to_sym] += 1
  }
  pp played_champions
end

def build_champ_hash(api)
  champs = []
  list = api.champions
  list = list.fetch(:data)
  list.each {|_key, val| champs << val}
  champs
end

league_api = League.new(api_key)
champions = build_champ_hash(league_api)
puts "Enter Summoner Name"
name = gets.chomp
list = match_list_from_summoner_name(name, league_api)
champions_played(list, champions)
