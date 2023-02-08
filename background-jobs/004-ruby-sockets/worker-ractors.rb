require 'base64'
require 'socket'

@queue = Ractor.new do
  loop do
    Ractor.yield(Ractor.receive, move: true)
  end
end

trap("SIGINT") do
  system("rm myqueue.sock")
  exit(0)
end

CPUS = (ARGV[0] || 2).to_i

workers = CPUS.times.map do
  Ractor.new(@queue) do |queue|
    wid = Ractor.current.object_id
    puts "Started worker #{wid}"

    loop do
      client = queue.take
      line = client.gets

      puts "[#{wid}][#{Time.now}] Encoded: #{line.chop} | Decoded: #{Base64.decode64(line)}"
      client.close
    end
  end
end

listener = Ractor.new(@queue) do |queue|
  socket = Socket.new(:UNIX, :STREAM)
  addr = Socket.sockaddr_un('myqueue.sock')

  socket.bind(addr)
  socket.listen(32)

  puts "Waiting for jobs in the queue..."

  loop do
    client, _ = socket.accept

    queue.send(client, move: true)
  end
end

loop do
  Ractor.select(listener, *workers)
end
