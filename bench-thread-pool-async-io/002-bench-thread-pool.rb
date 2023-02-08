require 'benchmark'
require 'net/http'
require 'uri'

THREAD_POOL_MAX = 4

###
# 10 | threads > pool (Concurrency)
# 30 | threads =~ pool
# 50 | pool > threads (Thread cost / context switch / very slow IO)
COUNT = 50

def http_get
  uri = URI('https://jsonplaceholder.typicode.com/todos/1')
  Net::HTTP.get(uri)
end

def threads
  COUNT.times.map do
    Thread.new { http_get }
  end.each(&:join)
end

def thread_pool
  queue = []
  mutex = Mutex.new
  emitter = ConditionVariable.new

  THREAD_POOL_MAX.times do
    Thread.new do
      loop do
        mutex.synchronize do
          if queue.size == 0
            emitter.wait(mutex)
          end

          job = queue.shift
          job.call
        end
      end
    end
  end

  COUNT.times do
    mutex.synchronize do
      job = -> { http_get }
      queue << job
      emitter.signal
    end
  end

  main_mutex = Mutex
  while queue.size > 0
    sleep 0.05
  end
end

Benchmark.bm do |x|
  x.report('threads') {  threads }
  x.report('thread pool') {  thread_pool }
end
