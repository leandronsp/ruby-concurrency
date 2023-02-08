require 'base64'

queue = []

puts "Waiting for jobs in the queue..."

# Worker Thread
Thread.new do
  loop do
    job = queue.shift

    if job
      puts "[#{Time.now}] Encoded: #{job.chop} | Decoded: #{Base64.decode64(job)}"
    end
  end
end

# Enqueuer
loop do
  sleep 0.05
  print "Digite qualquer coisa: "
  option = gets.chomp

  queue.push(Base64.encode64(option))
end
