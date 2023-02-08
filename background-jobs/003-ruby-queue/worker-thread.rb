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
    #next unless encoded

    unless encoded
      until queue.any?
        puts "Going to sleep..."
        sleep
      end
    end

    puts "[#{wid}][#{Time.now}] Encoded: #{encoded.chop} | Decoded: #{Base64.decode64(encoded)}"
  end
end

15.times do |index|
  queue.push(Base64.encode64("hello_#{index}"))
end

while queue.any?
  puts 'Waiting queue to be empty...'
  sleep 0.05
end
