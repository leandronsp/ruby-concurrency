require 'benchmark'
require 'net/http'
require 'uri'

###
# 10 | threads > sync (Concurrency)
# 50 | sync > threads (Thread cost / context switch / very slow IO)
COUNT = 10

def http_get
  uri = URI('https://jsonplaceholder.typicode.com/todos/1')
  Net::HTTP.get(uri)
end

def sync
  COUNT.times { http_get }
end

def threads
  COUNT.times.map do
    Thread.new { http_get }
  end.each(&:join)
end

Benchmark.bm do |x|
  x.report('sync')    {  sync    }
  x.report('threads') {  threads }
end
