require 'benchmark'

def sync
  10.times do
    sleep 0.5
  end
end

def threads
  10.times.map do
    Thread.new do
      sleep 0.5
    end
  end.each(&:join)
end

def fibers
  10.times.map do
    Fiber.new do
      sleep 0.5
    end
  end.each(&:resume)
end

def forking
  10.times.map do
    fork do
      sleep 0.5
    end
  end

  Process.waitall
end

Benchmark.bm do |x|
  x.report('sync')    {  sync    }
  x.report('threads') {  threads }
  x.report('fibers')  {  fibers  }
  x.report('forking') {  forking }
end
