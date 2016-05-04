Gem::Specification.new do |s|
  s.name        = 'leagueapi'
  s.version     = '0.1.0'
  s.date        = '2016-05-03'
  s.summary     = 'Simple League API'
  s.description = 'A Simple League of Legends API wrapper.'
  s.authors     = ['Derek Stride']
  s.email       = 'djgstride@gmail.com'
  s.files       = Dir['Rakefile', '{bin,lib,man,test,spec}/**/*', 'README*', 'LICENSE*'] & `git ls-files -z`.split("\0")
  s.homepage    = 'https://github.com/DerekStride/league-api'
  s.license     = 'MIT'
  s.add_development_dependency 'rspec', '~> 3.4'
end
