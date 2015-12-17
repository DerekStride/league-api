require 'spec_helper'
require_relative '../lib/league-api'

def api_key
  api_file_path = File.join(Dir.home, '.riot', 'credentials')
  File.read(api_file_path).chomp
end

describe API::LeagueAPI do
  before :each do
    @uut = API::LeagueAPI.new(api_key)
  end

  describe '#new' do
    it 'takes an api token and returns an intance of API::LeagueAPI' do
      expect(@uut).to be_an_instance_of(API::LeagueAPI)
    end
  end
end
