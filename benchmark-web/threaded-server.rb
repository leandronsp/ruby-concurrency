require 'socket'
require 'open-uri'

PORT, CONCURRENCY = ARGV.values_at(0, 1).map(&:to_i)
@queue = Queue.new

socket = TCPServer.new(PORT)
puts "Listening to the port #{PORT}..."

CONCURRENCY.times do
  Thread.new do
    loop do
      client = @queue.pop

      client.puts("HTTP/1.1 200\r\nContent-Type: text/html\r\n\r\n<h1>Yo!</h1>")
      client.close
    end
  end
end

loop do
  client = socket.accept

  @queue.push(client)
end
