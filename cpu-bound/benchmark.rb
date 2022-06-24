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
  end.each(&:value)
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

def ractors
  10.times.map do
    Ractor.new do
      fib(30)
    end
  end.each(&:take)
end

require 'celluloid'

Celluloid.boot

def celluloid
  10.times.map do
      Celluloid::Future.new do
      fib(30)
    end
  end.each(&:value)
end

Benchmark.bm do |x|
  x.report('sync')    {  sync    }
  x.report('threads') {  threads }
  x.report('fibers')  {  fibers  }
  x.report('forking') {  forking }
  x.report('ractors') {  ractors }
  x.report('celluloid') {  celluloid }
end
