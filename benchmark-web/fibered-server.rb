require 'socket'
require 'fiber_scheduler'
require 'open-uri'
require 'json'

Fiber.set_scheduler(FiberScheduler.new)

PORT = ARGV[0].to_i

socket = TCPServer.new(PORT)
puts "Listening to the port #{PORT}..."

Fiber.schedule do
  loop do
    client = socket.accept

    Fiber.schedule do
      client.puts("HTTP/1.1 200\r\nContent-Type: text/html\r\n\r\n<h1>Yo</h1>")
      client.close
    end
  end
end
