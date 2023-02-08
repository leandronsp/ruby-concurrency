require './lib/cractor-queue'
require './lib/ractor-queue'

#@queue = Queue.new
#@queue = CractorQueue.new
@queue = RactorQueue.new

# Background
Thread.new do
  wid = Thread.current.object_id
  puts "Started worker #{wid}"

  loop do
    name = @queue.pop

    puts "[#{wid}][#{Time.now}] Hello, #{name}"
  end
end

# Enqueuer
loop do
  sleep 0.05
  print "Digite seu nome: "
  name = gets.chomp

  @queue.push(name)
end
