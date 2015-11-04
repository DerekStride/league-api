require_relative 'league'
require 'pp'
class Stats
  def initialize(name)
    @summoner_name = name
    @league_api = League.new(api_key)
    @summoner_id = summoner_id_from_name(name)
    @match_list = @league_api.match_list(@summoner_id)
    @champions = build_champ_hash
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
    played_champions = Hash.new(0)
    # pp match_list
    matches = @match_list.fetch(:matches)
    matches.each {|match|
      played_champions[champion_key_from_id(@champions, match.fetch(:champion)).to_sym] += 1
    }
    played_champions
  end

  def build_champ_hash
    champs = []
    list = @league_api.champions
    list = list.fetch(:data)
    list.each {|_key, val| champs << val}
    champs
  end

  def calculate_over_time_data(match_list, name, api)

  end
end
league_api = League.new(api_key)
champions = build_champ_hash(league_api)
puts "Enter Summoner Name"
name = gets.chomp
list = match_list_from_summoner_name(name, league_api)
#match id test 1_942_658_534
pp league_api.match(1_942_658_534)
# champions_played(list, champions)
