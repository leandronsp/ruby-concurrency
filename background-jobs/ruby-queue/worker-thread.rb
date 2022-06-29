require 'base64'
require_relative './my-queue'

queue = MyQueue.new

puts "Waiting for jobs in the queue..."

# Background
worker = Thread.new do
  wid = Thread.current.object_id
  puts "Started worker #{wid}"

  loop do
    encoded = queue.pop
    next unless encoded

    puts "[#{wid}][#{Time.now}] Encoded: #{encoded.chop} | Decoded: #{Base64.decode64(encoded)}"
  end
end

queue.push(Base64.encode64('hello'))
queue.push(Base64.encode64('world'))

while queue.any?
  puts 'Waiting queue to be empty...'
  sleep 0.05
end
