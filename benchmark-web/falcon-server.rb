require 'rack'
require 'rack/handler/falcon'

PORT = ARGV[0].to_i

app = -> (env) do
  [200, { 'Content-Type' => 'text/html' }, ['<h1>Yo</h1>']]
end

Rack::Handler::Falcon.run app, Host: '0.0.0.0', Port: PORT
