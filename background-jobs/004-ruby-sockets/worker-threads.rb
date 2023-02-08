require 'base64'
require 'socket'
require './background-jobs/ruby-queue/my-synchronized-queue'

socket = Socket.new(:UNIX, :STREAM)
addr = Socket.sockaddr_un('myqueue.sock')

socket.bind(addr)
socket.listen(32)

puts "Waiting for jobs in the queue..."

@queue = MySynchronizedQueue.new

trap("SIGINT") do
  system("rm myqueue.sock")
  exit(0)
end

CONCURRENCY = (ARGV[0] || 2).to_i

CONCURRENCY.times do
  Thread.new do
    wid = Thread.current.object_id
    puts "Started worker #{wid}"

    loop do
      client = @queue.pop
      line = client.gets

      puts "[#{wid}][#{Time.now}] Encoded: #{line.chop} | Decoded: #{Base64.decode64(line)}"
      client.close
    end
  end
end

loop do
  client, _ = socket.accept

  @queue.push(client)
end
