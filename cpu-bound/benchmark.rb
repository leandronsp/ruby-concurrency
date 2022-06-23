require 'benchmark'

def fib(n)
  n < 2 ? n : fib(n - 1) + fib(n - 2)
end

def sync
  10.times do
    fib(30)
  end
end

def threads
  10.times.map do
    Thread.new do
      fib(30)
    end
  end.each(&:join)
end

def fibers
  10.times.map do
    Fiber.new do
      fib(30)
    end
  end.each(&:resume)
end

def forking
  10.times do
    fork do
      fib(30)
    end
  end

  Process.waitall
end

Benchmark.bm do |x|
  #x.report('sync')    {  sync    }
  x.report('threads') {  threads }
  #x.report('fibers')  {  fibers  }
  #x.report('forking') {  forking }
end
