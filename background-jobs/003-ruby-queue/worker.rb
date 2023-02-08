require 'base64'
require_relative './my-synchronized-queue'

queue = MySynchronizedQueue.new

puts "Waiting for jobs in the queue..."

Thread.new do
  loop do
    job = queue.pop

    puts "[#{Time.now}] Encoded: #{job.chop} | Decoded: #{Base64.decode64(job)}"
  end
end

100.times do |index|
  queue.push(Base64.encode64("hello_#{index}"))
end

while queue.any?
  puts 'Waiting queue to be empty...'
  sleep 0.05
end
