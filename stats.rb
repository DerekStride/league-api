require_relative 'league'
require 'pp'

# Summoner Class
class Summoner
  attr_reader :name, :id, :matchlist_ids, :champion_stats

  def initialize(name, api_key)
    @name = name
    api = League.new(api_key)
    @id = api.summoner_byname(@name).fetch(@name.to_sym).fetch(:id)
    matchlist = api.match_list(@id)
    matches = matchlist.fetch(:matches)
    @matchlist_ids = matches.map { |match| match.fetch(:matchId) }
    champs_played = champions_played(matchlist, api)
    @champion_stats = champions_played_frequency(matchlist, champs_played, api)
  end
end

def api_key
  api_file_path = File.join(Dir.home, '.riot', 'credentials')
  File.read(api_file_path).chomp
end

def match_list_from_summoner_name(name, api)
  summoner = api.summoner_byname(name)
  api.match_list(summoner.fetch(name.to_sym).fetch(:id))
end

def champions_played_frequency(match_list, champions, api)
  champs = champ_keys(api)
  champions.each { |_, h| h[:total_played] = 0 }
  matches = match_list.fetch(:matches)
  matches.each do |match|
    champ = match.fetch(:champion).to_s.to_sym
    champions[champs.fetch(champ).to_sym][:total_played] += 1
  end
  champions
end

def champ_keys(api)
  api.champions(champData: 'keys').fetch(:keys)
end

def champions_played(match_list, api)
  played_champs = {}
  champs = champ_keys(api)
  matches = match_list.fetch(:matches)
  matches.each do |match|
    champ = match.fetch(:champion).to_s.to_sym
    played_champs[champs.fetch(champ).to_sym] = {}
  end
  played_champs
end

puts 'Enter Summoner Name'
name = gets.chomp.sub(' ', '').downcase

s = Summoner.new(name, api_key)

# pp champ_keys(League.new(api_key))

pp s.id
pp s.matchlist_ids
pp s.champion_stats
