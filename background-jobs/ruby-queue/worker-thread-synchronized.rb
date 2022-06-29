require 'base64'
require_relative './my-synchronized-queue'

queue = MySynchronizedQueue.new

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

# Enqueuer
loop do
  sleep 0.05
  print "Digite qualquer coisa: "
  option = gets.chomp

  queue.push(Base64.encode64(option))
end
