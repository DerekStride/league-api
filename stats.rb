require_relative 'league'
require 'pp'

class Stats
  attr_accessor :match_list
  def initialize(name)
    @summoner_name = name
    @league_api = League.new(api_key)
    @summoner_id = summoner_id_from_name(name)
    @match_list = @league_api.match_list(@summoner_id)
    @champions = champ_keys
    @champions_played = champions_played
  end

  def match_list_from_summoner_name(name)
    name.downcase!
    summoner = @league_api.summoner_byname(name)
    @league_api.match_list(summoner.fetch(name.to_sym).fetch(:id))
  end

  def summoner_id_from_name(name)
    name.downcase!
    summoner = @league_api.summoner_byname(name)
    summoner.fetch(name.to_sym).fetch(:id)
  end

  def champion_key_from_id(champs, id)
    champs.each {|champion|
      if champion.fetch(:id) == id
        return champion.fetch(:key)
      end
    }
  end

  def champions_played
    played_champs = Hash.new(0)
    champs = champ_keys
    matches = @match_list.fetch(:matches)
    matches.each do |match|
    played_champs[champs.fetch(match.fetch(:champion).to_s.to_sym).to_sym] += 1
    end
    played_champs
  end

  def champ_keys
    @league_api.champions(champData: 'keys').fetch(:keys)
  end

  def calculate_over_time_data(match_list, name, api)

  end
end

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

def participant_identity(identities, summonerID)
	identities.each do |participant|
		next unless participant.fetch(:player).fetch(:summonerId) == summonerID ||
								participant.fetch(:player).fetch(:summonerId) == summonerID
		return participant.fetch(:participantId)
	end
	return 0
end

def to_stats(matchlist, summonerID)
	matchlist.map do |match|
		participantID = participant_identity(match.fetch(:participantIdentities), summonerID)
		match
			.fetch(:participants)
			.select { |stats| stats.fetch(:participantId) == participantID }
	end.flatten
end

puts 'Enter Summoner Name'
name = 'ugerest' # gets.chomp.sub(' ', '').downcase

league_api = League.new(api_key)
s = Summoner.new(name, api_key)

stats = Stats.new(name)
# pp stats.match_list


# pp champ_keys(League.new(api_key))
# pp s.matchlist_ids
# pp s.id
pp to_stats(s.matchlist_ids[0..5].map { |mID| league_api.match(mID) } , s.id)
# pp s.champion_stats

#

#list = match_list_from_summoner_name(name, league_api)
#match id test 1_942_658_534

#pp league_api.match(1_942_658_534)
# champions_played(list, champions)


