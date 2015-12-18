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
    @id2_sym = @id.to_s.to_sym
    @name2 = 'MeloDemelo'
    @ids = "#{@id},#{@id2}"
  end

  before :each do
    @uut = API::LeagueAPI.new(api_key)
  end

  describe '#match' do
    it 'should return a hash of the match data' do
      match = @uut.match(2_001_601_879)
      expect(match).to include(
        region: 'NA',
        participants: an_instance_of(Array)
      )
    end
  end

  describe '#champions' do
    it 'should return a hash of all the champions' do
      champs = @uut.champions
      expect(champs).to include(
        data: an_instance_of(Hash)
      )
      expect(champs[:data].length).to be > 100
    end
  end

  describe '#champion' do
    it 'should return the specific champion data' do
      aatroxid = 266
      aatrox = @uut.champion(aatroxid)
      expect(aatrox).to include id: 266, name: 'Aatrox'
    end
  end

  describe '#items' do
    it 'should return a hash of all the items' do
      items = @uut.champions
      expect(items).to include(
        data: an_instance_of(Hash)
      )
      expect(items[:data].length).to be > 100
    end
  end

  describe '#item' do
    it 'should return the specific item data' do
      item = @uut.item(1410)
      expect(item).to include id: 1410
    end
  end

  describe '#masteries' do
    it 'should return a hash of all the masteries' do
      masteries = @uut.champions
      expect(masteries).to include(
        data: an_instance_of(Hash)
      )
      expect(masteries[:data].length).to be > 10
    end
  end

  describe '#mastery' do
    it 'should return the specific mastery data' do
      mastery = @uut.mastery(6121)
      expect(mastery).to include id: 6121
    end
  end

  describe '#runes' do
    it 'should return a hash of all the runes' do
      runes = @uut.champions
      expect(runes).to include(
        data: an_instance_of(Hash)
      )
      expect(runes[:data].length).to be > 50
    end
  end

  describe '#rune' do
    it 'should return the specific rune data' do
      rune = @uut.rune(5235)
      expect(rune).to include id: 5235
    end
  end

  describe '#summoner_spells' do
    it 'should return a hash of all the summoner spells' do
      spells = @uut.champions
      expect(spells).to include(
        data: an_instance_of(Hash)
      )
      expect(spells[:data].length).to be > 5
    end
  end

  describe '#summoner_spell' do
    it 'should return the specific summoner spell data' do
      spell = @uut.summoner_spell(12)
      expect(spell).to include id: 12
    end
  end

  describe '#languages' do
    it 'should return an array of languages' do
      languages = @uut.languages
      expect(languages).to be_instance_of(Array)
      expect(languages).to include 'en_US'
      expect(languages.length).to be > 10
    end
  end

  describe '#map' do
    it 'should return map ids' do
      map = @uut.map
      expect(map).to include(
        data: an_instance_of(Hash)
      )
      expect(map[:data].length).to be > 3
    end
  end

  describe '#realm' do
    it 'tshould return a hash' do
      realm = @uut.realm
      expect(realm).to be_instance_of(Hash)
    end
  end

  describe '#versions' do
    it 'should return an array of versions' do
      versions = @uut.versions
      expect(versions).to include '5.24.2', '5.23.1'
    end
  end
end
