require 'base64'
require_relative './my-synchronized-queue'

queue = MySynchronizedQueue.new

puts "Waiting for jobs in the queue..."

# Background

2.times do
  Thread.new do
    wid = Thread.current.object_id
    puts "Started worker #{wid}"

    loop do
      encoded = queue.pop

      puts "[#{wid}][#{Time.now}] Encoded: #{encoded.chop} | Decoded: #{Base64.decode64(encoded)}"
    end
  end
end

100.times do |index|
  queue.push(Base64.encode64("hello_#{index}"))
end

while queue.any?
  puts 'Waiting queue to be empty...'
  sleep 0.05
end
