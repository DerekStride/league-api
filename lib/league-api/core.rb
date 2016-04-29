require 'net/http'
require 'json'
require 'jsoncache'

module API
  module League
    # API::League::Core contains the core functionality for the riot API
    #
    # Author::    Derek Stride  (mailto:djgstride@gmail.com)
    # License::   MIT
    #
    # This module provides an easy to use method +get_response+ with built in
    # caching using JSONCache.
    module Core
      attr_accessor :symbolize_json, :retries

      private

      # Performs a get request on the specified uri and will cache it.
      #
      # ==== Parameters
      #
      # +uri+:: +String+ The endpoint to query.
      # +delta+:: +Fixnum+ The expiry time for the cache (0 for no expiration).
      # +params+:: +Hash+ A hash of the optional parameters for the request.
      def get_response(uri, params = {})
        uri.query = URI.encode_www_form(params.merge(api_key: @api))
        query(uri)
      end

      # Queries the League API and retries upon recoverable failure
      #
      # ==== Parameters
      #
      # +uri+:: +String+ The endpoint to query.
      def query(uri) # :doc:
        @retries.times do |_|
          response = Net::HTTP.get_response(uri)
          if %w(429 500 503).include?(response.code)
            sleep(response['retry-after'].to_i || 2)
          else
            return parse_response(response)
          end
        end
      end

      # Maps a uri to a key for the cache
      #
      # ==== Parameters
      #
      # +uri+:: +String+ The endpoint for a query to convert to a cache key.
      def uri_to_key(uri)
        uri.to_s.gsub(%r{[\.\/]|https:\/\/.*v\d\.\d|\?api_key=.*}, '')
      end

      # Parses the JSON response and logs errors if they occur.
      #
      # ==== Parameters
      #
      # +response+:: +HTTPResponse+ The HTTP Response
      def parse_response(response)
        bad_response(response)
        result = JSON.parse(response.body, symbolize_names: @symbolize_json)
        result
      end

      # Logs errors unless you get a HTTP Success.
      #
      # ==== Parameters
      #
      # +response+:: +HTTPResponse+ The HTTP Response
      def bad_response(response)
        puts 'ERROR:' \
        "\nCode: #{response.code}" \
        "\nBody: #{response.body}" unless response.is_a?(Net::HTTPSuccess)
      end
    end
  end
end
