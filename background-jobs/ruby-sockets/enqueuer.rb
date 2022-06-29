require 'socket'
require 'faker'
require 'base64'

initial_time = Time.now

ARGV[1].to_i.times do |idx|
  socket = Socket.new(:UNIX, :STREAM)

  addr = Socket.sockaddr_un('myqueue.sock')
  socket.connect(addr)

  name = ARGV[0]
  encoded = Base64.encode64("#{name}-#{idx}")

  socket.puts(encoded)
rescue
  next
ensure
  socket.close
end

puts "Enqueued in #{Time.now - initial_time} seconds"
