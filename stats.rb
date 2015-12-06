require_relative 'league'
require 'pp'

# A module to encapsulate functions to calculate league stats.
module LeagueStats
  module_function

  def champion_play_stats_by_summoner(summoner_id)
    matchlist = @api.matchlist(summoner_id)
    results = champion_win_loss_count_by_matchlist(summoner_id, matchlist)
    champ_freq = champion_play_frequency_by_matchlist(matchlist)
    champ_stats = champion_stats_by_summoner(summoner_id)
    results.each do |champ, _|
      results[champ][:freq] = champ_freq[champ]
      results[champ][:stats] = champ_stats[champ]
    end
    results[:total] = champion_stats_totals(results, champ_freq, champ_stats)
    results
  end

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

  ########################################################################
  # champion stats by matchlist
  ########################################################################

  def champion_win_loss_count_by_matchlist(summoner_id, matchlist)
    champion_wins = champion_win_count_by_matchlist(summoner_id, matchlist)
    champion_freq = champion_play_frequency_by_matchlist(matchlist)
    result = {}
    champion_freq.each do |champ, freq|
      result[champ] ||= Hash.new(0)
      result[champ][:wins] = champion_wins[champ] || 0
      result[champ][:losses] = freq - result[champ][:wins]
    end
    result
  end

  def champion_win_count_by_matchlist(summoner_id, matchlist)
    champs = champion_keys
    result = Hash.new(0)
    matchlist.fetch(:matches).each do |match|
      champion = champs[match[:champion].to_s.to_sym]
      if summoner_won_match?(summoner_id, @api.match(match.fetch(:matchId)))
        result[champion] += 1
      end
    end
    result
  end

  def champion_play_frequency_by_matchlist(matchlist)
    champs = champion_keys
    result = Hash.new(0)
    matchlist.fetch(:matches).each do |match|
      champion = champs.fetch(match.fetch(:champion).to_s.to_sym)
      result[champion] += 1
    end
    result
  end

  def champion_stats_by_summoner(summoner_id)
    stats_by_champion = @api.stats(summoner_id)
    champs = champion_keys
    result = {}
    stats_by_champion.fetch(:champions).each do |stats|
      champion = champs[stats[:id].to_s.to_sym]
      result[champion || :total] = stats[:stats]
    end
    result
  end

  def champion_stats_totals(champ_win_loss, champ_freq, champ_stats)
    result = {}
    result[:stats] = champ_stats[:total]
    result[:win] = champ_win_loss.map { |_, stats| stats[:wins] }
                   .reduce(:+)
    result[:losses] = champ_win_loss.map { |_, stats| stats[:losses] }
                      .reduce(:+)
    result[:freq] = champ_freq.map { |_, freq| freq }
                    .reduce(:+)
    result
  end

  ########################################################################
  # Stats
  ########################################################################

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

pp @league_api.stats(name)
# pp LeagueStats.champion_play_stats_by_summoner(name)

pp Time.now - start
