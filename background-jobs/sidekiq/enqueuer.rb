require 'sidekiq'
require 'base64'
require_relative './my-worker'

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://redis:6379/0' }
end

initial_time = Time.now

ARGV[1].to_i.times do |idx|
  name = ARGV[0]
  encoded = Base64.encode64("#{name}-#{idx}")

  MyWorker.perform_async(encoded)
end

puts "Enqueued in #{Time.now - initial_time} seconds"
