require 'fiber_scheduler'
require 'open-uri'

initial_time = Time.now

MODE = ARGV[0]
TIMES = ARGV[1].to_i

if MODE == 'thread'
  TIMES.times.map do
    Thread.new do
      URI.open("http://localhost:3000/")
    end
  end.each(&:join)
elsif MODE == 'fiber'
  FiberScheduler do
    TIMES.times do
      Fiber.schedule do
        URI.open("http://localhost:3000/")
      end
    end
  end
end

puts "Finished in #{Time.now - initial_time}s"
