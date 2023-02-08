require 'base64'

queue = []

puts "Waiting for jobs in the queue..."

loop do
  job = queue.shift

  puts "[#{Time.now}] Encoded: #{job.chop} | Decoded: #{Base64.decode64(job)}"
end

loop do
  sleep 0.05
  print "Digite qualquer coisa: "
  option = gets.chomp

  queue.push(Base64.encode64(option))
end
