require 'base64'
require 'redis'
require 'json'

queue = Redis.new(host: 'redis')

puts "Waiting for jobs in the queue..."

CPUS, CONCURRENCY = ARGV[0].split(':').map(&:to_i)

CPUS.times do
  fork do
    wid = Process.pid
    puts "Started worker #{wid}"

    CONCURRENCY.times.map do
      Thread.new do
        loop do
          _queue_name, data = queue.blpop('myqueue')

          puts "[#{wid}][#{Time.now}] Encoded: #{data} | Decoded: #{Base64.decode64(data)}"
        end
      end
    end.each(&:join)
  end
end

Process.waitall
