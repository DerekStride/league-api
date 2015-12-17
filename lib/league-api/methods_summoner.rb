module API
  module League
    module Methods
      # API::League::Methods::Summoner provides methods to get Static API Data
      #
      # Author::    Derek Stride  (mailto:djgstride@gmail.com)
      # License::   MIT
      #
      # Requires implementing +get_response(uri, delta, params = {})+, see
      # API::League::Core for an example.
      module Summoner
        def summoner_byname(name)
          path_val = URI.encode_www_form_component(name)
          uri = URI("#{@summoner_data_url}/by-name/#{path_val}")
          get_response(uri, 0)
        end

        def summoner_by_id(id)
          path_val = URI.encode_www_form_component(id)
          uri = URI("#{@summoner_data_url}/#{path_val}")
          get_response(uri, 0)
        end

        def summoner_masteries(id)
          uri = URI("#{@summoner_data_url}/#{id}/masteries")
          get_response(uri, 0)
        end

        def summoner_runes(id)
          path_val = URI.encode_www_form_component(id)
          uri = URI("#{@summoner_data_url}/#{path_val}/runes")
          get_response(uri, 0)
        end

        def summoner_name(id)
          path_val = URI.encode_www_form_component(id)
          uri = URI("#{@summoner_data_url}/#{path_val}/name")
          get_response(uri, 0)
        end
      end
    end
  end
end
