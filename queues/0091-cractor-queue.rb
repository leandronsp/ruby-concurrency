require './lib/cractor'

queue = Cractor.new do |inbox, outbox|
  loop do
    outbox.push(inbox.pop)
  end
end

queue.push(1)
queue.push(2)
queue.push(3)

puts queue.pop
puts queue.pop
puts queue.pop
