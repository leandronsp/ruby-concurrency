require 'base64'

name = ARGV[0]
encoded = Base64.encode64(name)

File.write('myqueue', encoded)

puts "Enqueued jobs"
