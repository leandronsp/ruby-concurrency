require 'socket'

PORT = ARGV[0].to_i

socket = TCPServer.new(PORT)
puts "Listening to the port #{PORT}..."

loop do
  client = socket.accept

  client.puts("HTTP/1.1 200\r\nContent-Type: text/html\r\n\r\n<h1>Yo!</h1>")
  client.close
end
