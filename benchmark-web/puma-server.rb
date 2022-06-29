require 'rack'
require 'rack/handler/puma'

PORT = ARGV[0].to_i
CONCURRENCY = ARGV[1]

app = -> (env) do
  [200, { 'Content-Type' => 'text/html' }, ['<h1>Yo</h1>']]
end

Rack::Handler::Puma.run app, Host: '0.0.0.0', Port: PORT, Threads: CONCURRENCY

### Run with forking workers ###
## > WEB_CONCURRENCY=4 ruby benchmark-web/puma-server.rb 3000 8:32
