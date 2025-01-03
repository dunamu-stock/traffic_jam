Gem::Specification.new do |s|
  s.name        = "traffic_jam"
  s.version     = "1.3.0"
  s.licenses    = ["MIT"]
  s.summary     = "Library for time-based rate limiting"
  s.description = "Library for Redis-backed time-based rate limiting"
  s.authors     = ["Jim Posen"]
  s.email       = "jimpo@coinbase.com"
  s.files       = Dir.glob("lib/**/*.rb") + Dir.glob("scripts/**/*.lua")
  s.homepage    = "https://github.com/coinbase/traffic_jam"

  s.add_dependency 'redis', '>= 3.0', '< 6'
  s.add_development_dependency 'rake', '~> 13.0'
end