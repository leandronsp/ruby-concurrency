require 'base64'

## Cria o named pipe
File.mkfifo('myqueue')

puts "Waiting for jobs in the queue..."

loop do
  encoded = File.read('myqueue') # queue.pop

  # perform
  puts "[#{Time.now}] Encoded: #{encoded.chop} | Decoded: #{Base64.decode64(encoded)}"
end
