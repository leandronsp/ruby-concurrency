require 'redis'

redis = Redis.new(host: 'redis')

Ractor.new do
  redis.rpush('myqueue', 'leandro')
end.take