require 'redis'
require 'timecop'
require 'spy/integration'
require 'minitest/autorun'

require 'traffic_jam'

module RedisHelper
  @@redis = Redis.new(url: ENV['REDIS_URI'] || 'redis://localhost:6379')

  def setup
    super
    @@redis.flushdb
    @@redis.script(:flush)
  end

  def self.redis
    @@redis
  end
end
