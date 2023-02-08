require 'rack'
require 'rack/handler/puma'
require 'fiber_scheduler'
require 'open-uri'
require 'base64'
require 'cgi'
require 'json'

PORT = ARGV[0].to_i
CONCURRENCY = ARGV[1]

app = -> (env) do
  request = Rack::Request.new(env)
  params  = request.params
  encoded = CGI.unescape(params['encoded'])

  [200, { 'Content-Type' => 'application/json' }, [{ decoded: Base64.decode64(encoded) }.to_json]]
end

Rack::Handler::Puma.run app, Host: '0.0.0.0', Port: PORT, Threads: CONCURRENCY

### Run with forking workers ###
## > WEB_CONCURRENCY=4 ruby benchmark-web/puma-server.rb 3000 8:32
