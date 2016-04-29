require_relative 'methods_static'
require_relative 'methods_summoner'

module API
  module League
    # API::League::Methods provides methods to talk to the Riot API, requires
    # implementing a get_response method to do the API calls
    #
    # Author::    Derek Stride  (mailto:djgstride@gmail.com)
    # License::   MIT
    #
    # Requires implementing +get_response(uri, delta, params = {})+, see
    # API::League::Core for an example.
    module Methods
      extend JSONCache
      include API::League::Methods::Static
      include API::League::Methods::Summoner

      ########################################################################
      # Matchlist
      ########################################################################
      def matchlist(summoner_id, params = {})
        id = normalize_summoner_id(summoner_id)
        path_val = URI.encode_www_form_component(id)
        uri = URI("#{@matchs_url}/#{path_val}")
        get_response(uri, params)
      end

      ########################################################################
      # Stats
      ########################################################################
      def stats(summoner_id, params = {})
        id = normalize_summoner_id(summoner_id)
        path_val = URI.encode_www_form_component(id)
        uri = URI("#{@stats_url}/#{path_val}/ranked")
        get_response(uri, params)
      end

      cache :stats,     expiry: 300
      cache :matchlist, expiry: 300

      private

      def normalize_summoner_id(id)
        return id if id.is_a? Fixnum
        summoner_id_from_name(id)
      end

      def summoner_id_from_name(name)
        id = name.chomp.delete(' ').downcase
        summoner = summoner_byname(id)
        if @symbolize_json
          return summoner.fetch(id.to_sym).fetch(:id)
        else
          return summoner.fetch(id).fetch('id')
        end
      end
    end
  end
end
