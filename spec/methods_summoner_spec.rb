require 'spec_helper'
require_relative '../lib/league-api'

def api_key
  api_file_path = File.join(Dir.home, '.riot', 'credentials')
  File.read(api_file_path).chomp
end

describe API::League do
  before :all do
    @name = 'ugerest'
    @id = 51_100_547
    @id_sym = @id.to_s.to_sym
    @id2 = 20_052_687
    @id2_sym = @id2.to_s.to_sym
    @name2 = 'MeloDemelo'
    @ids = "#{@id},#{@id2}"
  end

  before :each do
    @uut = API::LeagueAPI.new(api_key)
  end

  describe '#summoner_byname' do
    it 'should return a hash with the name and id' do
      actual = @uut.summoner_byname(@name)
      expect(actual).to include @name.to_sym
      expect(actual[@name.to_sym]).to include(
        id: @id,
        name: @name
      )
    end
  end

  describe '#summoner_by_id' do
    it 'should return a hash with the name and id' do
      actual = @uut.summoner_by_id(@id)
      expect(actual).to include @id_sym
      expect(actual[@id_sym]).to include(
        id: @id,
        name: @name
      )
    end
  end

  describe '#summoner_masteries' do
    it 'should return a hash of mastery pages' do
      actual = @uut.summoner_masteries(@id)
      expect(actual).to include @id_sym
      expect(actual[@id_sym]).to include(pages: an_instance_of(Array))
    end
  end

  describe '#summoner_runes' do
    it 'should return a hash of rune pages' do
      actual = @uut.summoner_runes(@id)
      expect(actual).to include @id_sym
      expect(actual[@id_sym]).to include(pages: an_instance_of(Array))
    end
  end

  describe '#summoner_name' do
    it 'should return a hash of summoner names' do
      actual = @uut.summoner_name(@ids)
      expect(actual).to match(
        @id_sym => @name,
        @id2_sym => @name2
      )
    end
  end
end
