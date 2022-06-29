require 'redis'
require 'base64'

initial_time = Time.now
queue = Redis.new(host: 'redis')

ARGV[1].to_i.times do |idx|
  name = ARGV[0]
  encoded = Base64.encode64("#{name}-#{idx}")

  queue.rpush('myqueue', encoded)
end

puts "Enqueued in #{Time.now - initial_time} seconds"
