require 'base64'

@queue = Array.new

50_000.times do |index|
  @queue.push(Base64.encode64("test#{index}"))
end

puts "[#{Thread.current.object_id}] Waiting for jobs..."

loop do
  job = @queue.shift

  unless job
    sleep until @queue.size > 0
  end

  puts "Encoded: #{job.strip} | Decoded: #{Base64.decode64(job)}"
end
