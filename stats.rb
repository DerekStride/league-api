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

  def api_key
    api_file_path = File.join(Dir.home, '.riot', 'credentials')
    File.read(api_file_path).chomp
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
    pp played_champs
  end

  def champ_keys
    @league_api.champions(champData: 'keys').fetch(:keys)
  end

  def calculate_over_time_data(match_list, name, api)

  end
end


#league_api = League.new(api_key)
puts 'Enter Summoner Name'
name = gets.chomp.sub(' ', '').downcase
stats = Stats.new(name)
pp stats.match_list
#list = match_list_from_summoner_name(name, league_api)
#match id test 1_942_658_534

#pp league_api.match(1_942_658_534)
# champions_played(list, champions)

#champions_played(list, league_api)
