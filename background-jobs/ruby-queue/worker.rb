require 'base64'
require_relative './my-queue'

queue = MyQueue.new

puts "Waiting for jobs in the queue..."

loop do
  encoded = queue.pop

  puts "[#{Time.now}] Encoded: #{encoded.chop} | Decoded: #{Base64.decode64(encoded)}"
end
