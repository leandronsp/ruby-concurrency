require 'base64'
require 'socket'
require 'fiber_scheduler'

socket = Socket.new(:UNIX, :STREAM)
addr = Socket.sockaddr_un('myqueue.sock')

socket.bind(addr)
socket.listen(32)

puts "Waiting for jobs in the queue..."

trap("SIGINT") do
  system("rm myqueue.sock")
  exit(0)
end

FiberScheduler do
  loop do
    client, _ = socket.accept

    Fiber.schedule do
      line = client.gets

      puts "[#{Time.now}] Encoded: #{line.chop} | Decoded: #{Base64.decode64(line)}"
      client.close
    end
  end
end
