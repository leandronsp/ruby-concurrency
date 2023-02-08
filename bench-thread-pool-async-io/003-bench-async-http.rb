require 'benchmark'
require 'json'
require 'net/http'
require 'uri'
require 'async'
require 'async/http/internet'
require 'async/barrier'

THREAD_POOL_MAX = 4

###
# 10 | threads > async > pool (Concurrency / async IO)
# 30 | async > threads =~ pool (async IO)
# 50 | async > pool > threads (async IO >>>>>>>>>>>)
COUNT = 50

def http_get(index)
  uri = URI("https://jsonplaceholder.typicode.com/todos/#{index + 1}")
  Net::HTTP.get(uri)
end

def threads
  responses = []

  COUNT.times.map do |index|
    Thread.new do
      response = http_get(index)
      responses << JSON.parse(response)
    end
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

  responses = []

  COUNT.times do |index|
    mutex.synchronize do
      job = -> do
        response = http_get(index)
        responses << JSON.parse(response)
      end

      queue << job
      emitter.signal
    end
  end

  while queue.size > 0
    sleep 0.05
  end
end

def async_http
  Async do
    internet = Async::HTTP::Internet.new
    barrier = Async::Barrier.new
    responses = []

    COUNT.times do |index|
      barrier.async do
        response = internet.get("https://jsonplaceholder.typicode.com/todos/#{index + 1}")
        responses << JSON.parse(response.read)
      end
    end

    barrier.wait
  end
end

Benchmark.bm do |x|
  #x.report('threads') {  threads }
  #x.report('thread pool') {  thread_pool }
  x.report('async http') {  async_http }
end
