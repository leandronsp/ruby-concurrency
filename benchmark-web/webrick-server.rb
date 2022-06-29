require 'rack'
require 'webrick'

PORT = ARGV[0].to_i

app = -> (env) do
  [200, { 'Content-Type' => 'text/html' }, ['<h1>Yo</h1>']]
end

Rack::Handler::WEBrick.run app, Host: '0.0.0.0', Port: PORT
