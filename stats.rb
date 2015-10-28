require_relative "league"

def get_api_key()
  api_file = File.open(ENV['HOME'] + '/.riot/credentials')
  credentials = api_file.read.delete("\n")
end

api = new league(get_api_key)

puts api.champions
