require 'base64'

queue = []
mutex = Mutex.new
emitter = ConditionVariable.new

puts "Waiting for jobs in the queue..."

# Worker Thread
Thread.new do
  loop do
    mutex.lock

    if queue.size == 0
      emitter.wait(mutex)
    end

    job = queue.shift

    mutex.unlock

    puts "[#{Time.now}] Encoded: #{job.chop} | Decoded: #{Base64.decode64(job)}"
  end
end

# Enqueuer
loop do
  sleep 0.05
  print "Digite qualquer coisa: "
  option = gets.chomp

  queue.push(Base64.encode64(option))
  emitter.signal
end
