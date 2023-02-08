require 'rack'
require 'rack/handler/falcon'
require 'fiber_scheduler'
require 'open-uri'
require 'base64'
require 'cgi'
require 'json'

PORT = ARGV[0].to_i

app = -> (env) do
  request = Rack::Request.new(env)
  params  = request.params
  encoded = CGI.unescape(params['encoded'])

  [200, { 'Content-Type' => 'application/json' }, [{ decoded: Base64.decode64(encoded) }.to_json]]
end

Rack::Handler::Falcon.run app, Host: '0.0.0.0', Port: PORT
