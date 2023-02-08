require 'socket'

PORT = ARGV[0].to_i
CPUS, CONCURRENCY = ARGV[1].split(':').map(&:to_i)

@queue = Ractor.new do
  loop do
    Ractor.yield(Ractor.receive, move: true)
  end
end

workers = CPUS.times.map do
  Ractor.new(@queue) do |queue|
    thread_queue = []
    mutex = Mutex.new
    emitter = ConditionVariable.new

    CONCURRENCY.times do
      Thread.new do
        loop do
          mutex.synchronize do
            if thread_queue.size == 0
              emitter.wait(mutex)
            end

            job = thread_queue.shift
            job.call
          end
        end
      end
    end

    loop do
      mutex.synchronize do
        job = -> do
          client = queue.take

          client.puts("HTTP/1.1 200\r\nContent-Type: text/html\r\n\r\n<h1>Yo!</h1>")
          client.close
        end

        thread_queue << job
        emitter.signal
      end
    end
  end
end

listener = Ractor.new(@queue) do |queue|
  socket = TCPServer.new(PORT)
  puts "Listening to the port #{PORT}..."

  loop do
    client = socket.accept

    queue.send(client, move: true)
  end
end

loop do
  Ractor.select(listener, *workers)
end
