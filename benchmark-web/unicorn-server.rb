require 'rack'
require 'open-uri'
require 'unicorn-rails'

PORT = ARGV[0].to_i

app = -> (env) do
  [200, { 'Content-Type' => 'text/html' }, ['<h1>Yo</h1>']]
end

Rack::Handler::Unicorn.run app, Host: '0.0.0.0', Port: PORT

### Run ###
## > UNICORN_WORKERS=4 ruby benchmark-web/unicorn-server.rb 3000
