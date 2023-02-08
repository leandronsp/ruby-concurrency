require 'socket'
require 'open-uri'
require 'fiber_scheduler'

PORT = ARGV[0].to_i

socket = TCPServer.new(PORT)
puts "Listening to the port #{PORT}..."

Fiber.set_scheduler(FiberScheduler.new)

loop do
  client = socket.accept

  requests_count = 0

  5.times do
    Fiber.schedule do
      URI.open("http://localhost:4000/")
      requests_count += 1
    end
  end

  client.puts("HTTP/1.1 200\r\nContent-Type: text/html\r\n\r\n<h1>Performed #{requests_count} requests</h1>")
  client.close
end
