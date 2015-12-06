require_relative 'league'
require 'pp'

# A module to encapsulate functions to calculate league stats.
module LeagueStats
  module_function

  private

  module_function

  ########################################################################
  # Helpers
  ########################################################################

  def summoner_won_match?(id, match)
    participant_id = 0
    match.fetch(:participantIdentities).each do |participant|
      next unless participant[:player][:summonerId] == normalize_summoner_id(id)
      participant_id = participant.fetch(:participantId)
      break
    end

    match.fetch(:participants).each do |stats|
      next unless stats.fetch(:participantId) == participant_id
      return stats.fetch(:stats).fetch(:winner)
    end
  end

  def champion_keys
    # api.symbolize_json = false
    champs = @api.champions(champData: 'keys').fetch(:keys) # 'keys')
    result = {}
    champs.each do |k, v|
      result[k] = v.to_sym
    end
    result
  end

  ########################################################################
  # Summoner ID normalization
  ########################################################################

  def summoner_id_from_name(name)
    id = name.downcase
    summoner = @api.summoner_byname(id)
    summoner.fetch(id.to_sym).fetch(:id)
  end

  def normalize_summoner_id(id)
    return id if id.is_a? Fixnum
    summoner_id_from_name(id)
  end

  ########################################################################
  # API Key and API initialization
  ########################################################################

  def api_key
    api_file_path = File.join(Dir.home, '.riot', 'credentials')
    File.read(api_file_path).chomp
  end

  # For some reason api_key needs to be defined higher than
  # The instance variable calling it.
  @api = League.new(LeagueStats.api_key)
end

def api_key_path
  api_file_path = File.join(Dir.home, '.riot', 'credentials')
  File.read(api_file_path).chomp
end

@league_api = League.new(api_key_path)

# puts 'Enter Summoner Name'
name = 'ugerest' # gets.chomp.sub(' ', '').downcase

start = Time.now

# pp @league_api.stats(name)

matchlist = @league_api.matchlist(name).fetch(:matches).map { |h| h[:matchId] }

10.times do |_|
  start = Time.now.to_i
  matchlist[0..20].each do |match_id|
    @league_api.match(match_id)
  end
  pp Time.now.to_i - start
end

# pp LeagueStats.champion_play_stats_by_summoner(name)

pp Time.now - start
