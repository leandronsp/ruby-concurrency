require 'sidekiq'
require 'base64'

class MyWorker
  include Sidekiq::Worker

  def perform(encoded)
    puts "[#{Time.now}] Encoded: #{encoded} | Decoded: #{Base64.decode64(encoded)}"
  end
end
