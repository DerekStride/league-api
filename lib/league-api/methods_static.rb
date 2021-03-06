module API
  module League
    module Methods
      # API::League::Methods::Static provides methods to get Static API Data
      #
      # Author::    Derek Stride  (mailto:djgstride@gmail.com)
      # License::   MIT
      #
      # Requires implementing +get_response(uri, delta, params = {})+, see
      # API::League::Core for an example.
      module Static
        extend JSONCache

        def match(match_id, params = {})
          path_val = URI.encode_www_form_component(match_id)
          uri = URI("#{@baseurl}/api/lol/na/v2.2/match/#{path_val}")
          get_response(uri, params)
        end

        def champions(params = {})
          uri = URI("#{@static_data_url}/champion")
          get_response(uri, params)
        end

        def champion(champ_id, params = {})
          path_val = URI.encode_www_form_component(champ_id)
          uri = URI("#{@static_data_url}/champion/#{path_val}")
          get_response(uri, params)
        end

        def items(params = {})
          uri = URI("#{@static_data_url}/item")
          get_response(uri, params)
        end

        def item(item_id, params = {})
          path_val = URI.encode_www_form_component(item_id)
          uri = URI("#{@static_data_url}/item/#{path_val}")
          get_response(uri, params)
        end

        def masteries(params = {})
          uri = URI("#{@static_data_url}/mastery")
          get_response(uri, params)
        end

        def mastery(mastery_id, params = {})
          path_val = URI.encode_www_form_component(mastery_id)
          uri = URI("#{@static_data_url}/mastery/#{path_val}")
          get_response(uri, params)
        end

        def runes(params = {})
          uri = URI("#{@static_data_url}/rune")
          get_response(uri, params)
        end

        def rune(rune_id, params = {})
          path_val = URI.encode_www_form_component(rune_id)
          uri = URI("#{@static_data_url}/rune/#{path_val}")
          get_response(uri, params)
        end

        def summoner_spells(params = {})
          uri = URI("#{@static_data_url}/summoner-spell")
          get_response(uri, params)
        end

        def summoner_spell(summoner_spell_id, params = {})
          path_val = URI.encode_www_form_component(summoner_spell_id)
          uri = URI("#{@static_data_url}/summoner-spell/#{path_val}")
          get_response(uri, params)
        end

        def languages
          uri = URI("#{@static_data_url}/languages")
          get_response(uri)
        end

        def map(params = {})
          uri = URI("#{@static_data_url}/map")
          get_response(uri, params)
        end

        def realm
          uri = URI("#{@static_data_url}/realm")
          get_response(uri)
        end

        def versions
          uri = URI("#{@static_data_url}/versions")
          get_response(uri)
        end

        %i(match champion item mastery rune summoner_spell map languages realm versions).each do |method|
          cache method, expiry: 0
        end
        %i(champions items masteries runes summoner_spells).each do |method|
          cache method, expiry: 300
        end
      end
    end
  end
end
