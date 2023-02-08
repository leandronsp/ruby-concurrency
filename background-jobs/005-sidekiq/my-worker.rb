require 'sidekiq'
require 'open-uri'
require 'cgi'
require 'json'

class MyWorker
  include Sidekiq::Worker

  def perform(encoded)
    response = URI.open("http://localhost:3000/?encoded=#{CGI.escape(encoded)}").read

    puts "[#{Time.now}] Encoded: #{encoded} | Decoded: #{JSON.parse(response)['decoded']}"
  end
end
