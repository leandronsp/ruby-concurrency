require 'base64'
require 'socket'

socket = Socket.new(:UNIX, :STREAM)
addr = Socket.sockaddr_un('myqueue.sock')

socket.bind(addr)
socket.listen(2)

puts "Waiting for jobs in the queue..."

trap("SIGINT") do
  system("rm myqueue.sock")
  exit(0)
end

loop do
  client, _ = socket.accept # queue.pop
  line      = client.gets

  # perform
  puts "[#{Time.now}] Encoded: #{line.chop} | Decoded: #{Base64.decode64(line)}"

  # close the connection
  client.close
end
